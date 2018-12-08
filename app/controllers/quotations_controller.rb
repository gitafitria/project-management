class QuotationsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]

  before_action :set_quotation, only: [:show, :edit, :update, :destroy, :pdf, :export_email, :create_project]

  respond_to :html, :js, :json
  has_scope :by_projects, type: :array
  has_scope :by_creators, type: :array

  # GET /quotations
  # GET /quotations.json
  def index
    require 'will_paginate/array'

    authorize Quotation

    @quotations = apply_scopes(Quotation).valid.all

    if current_user.client?
      @quotations = @quotations.by_belongings([current_user.id])
    end

    respond_with do |format|
      format.html
      format.json { render json: QuotationsDatatable.new(view_context, @quotations) }
      format.js
    end
  end

  # GET /quotations/1
  # GET /quotations/1.json
  def show
    authorize @quotation
  end

  # GET /quotations/new
  def new
    @quotation = Quotation.new

    authorize @quotation
  end

  # GET /quotations/1/edit
  def edit
    authorize @quotation
  end

  # POST /quotations
  # POST /quotations.json
  def create
    @quotation = Quotation.new(quotation_params)

    respond_to do |format|
      if @quotation.save
        flash_label = 'Quotation was successfully created.'
        flash.now[:notice] = flash_label

        format.html { redirect_to @quotation, notice: flash_label }
        format.json { render :show, status: :created, location: @quotation }
        format.js
      else
        format.html { render :new }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /quotations/1
  # PATCH/PUT /quotations/1.json
  def update
    authorize @quotation

    respond_to do |format|
      if @quotation.update(quotation_params)
        flash_label = 'Quotation was successfully updated.'
        flash.now[:notice] = flash_label

        format.html { redirect_to @quotation, notice: flash_label }
        format.json { render :show, status: :ok, location: @quotation }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /quotations/1
  # DELETE /quotations/1.json
  def destroy
    authorize @quotation

    @quotation.is_valid = false
    @quotation.save
    respond_to do |format|
      format.html { redirect_to quotations_url, notice: 'Quotation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def pdf
    authorize @quotation

    filename = "quotation_#{@quotation.title}.pdf"
    file_path = Rails.root.join("public/pdfs/quotations/", filename)

    respond_to do |format|
      format.html {
        render pdf: "quotations/pdf",
              layout: "pdf",
              page_size: "a4",
              save_to_file: file_path,
              save_only: true
        send_file file_path, filename: filename
      }
      format.js {
        render pdf: "quotations/pdf",
              layout: "pdf",
              page_size: "a4",
              # save_to_file: 'C:\Users\Public\Downloads\invoice.pdf',
              save_to_file: file_path,
              save_only: true
        send_file file_path, filename: filename
      }
    end
  end

  def export_email
    authorize @quotation

    if deliver_email(@quotation, params[:email_sent_to])
      flash_label = 'Emails was successfully sent.'
      flash.now[:notice] = flash_label
    end

    respond_to do |format|
      format.js
    end
  end

  def create_project
    @project = Project.new(project_name: @quotation.title, quotation_id: @quotation.id, client_email: @quotation.email)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quotation
      @quotation = Quotation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quotation_params
      params.require(:quotation).permit(
        :content,
        :user_id,
        :project_id,
        :email,
        :title
        # :is_valid
      )
    end

    # email deliver
    def deliver_email(quotation, receivers = nil)
      filename = "quotation_#{@quotation.title}.pdf"
      file_path = Rails.root.join("public/pdfs/quotations/", filename)

      unless File.exist?(file_path)
        pdf = WickedPdf.new.pdf_from_string(
                render_to_string('layouts/quotation_pdf',
                  layout: "pdf",
                  page_size: "a4"
                )
              )
        File.open(Rails.root.join("public/pdfs/quotations/", filename), 'wb') do |file|
          file << pdf
        end
      end
      receivers.each do |r|
        QuotationMailer.export_to_email(quotation, r).deliver_later
      end
    end

end
