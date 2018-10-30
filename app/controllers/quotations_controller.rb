class QuotationsController < ApplicationController
  before_action :set_quotation, only: [:show, :edit, :update, :destroy, :pdf, :export_email]

  respond_to :html, :js, :json
  has_scope :by_projects, type: :array
  has_scope :by_creators, type: :array

  # GET /quotations
  # GET /quotations.json
  def index
    require 'will_paginate/array'

    @quotations = apply_scopes(Quotation).all
    respond_with do |format|
      format.html
      format.json { render json: QuotationsDatatable.new(view_context, @quotations) }
      format.js
    end
  end

  # GET /quotations/1
  # GET /quotations/1.json
  def show
  end

  # GET /quotations/new
  def new
    @quotation = Quotation.new
  end

  # GET /quotations/1/edit
  def edit
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
    @quotation.destroy
    respond_to do |format|
      format.html { redirect_to quotations_url, notice: 'Quotation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def pdf
    # filename = "invoice_#{@invoice.invoice_number}_#{@invoice.project.project_name}.pdf"
    # file_path = Rails.root.join("public/pdfs", filename)

    # respond_to do |format|
    #   # format.html { render pdf: "invoices/pdf", layout: "pdf", page_size: "a4" }
    #   format.html {
    #     unless File.exist?(file_path)
    #       render pdf: "invoices/pdf",
    #             layout: "pdf",
    #             page_size: "a4",
    #             # save_to_file: 'C:\Users\Public\Downloads\invoice.pdf',
    #             save_to_file: file_path,
    #             save_only: true
    #     end
    #     send_file file_path, filename: "invoice_#{@invoice.invoice_number}_#{@invoice.project.project_name}.pdf"
    #   }
    #   format.js {
    #     unless File.exist?(file_path)
    #       render pdf: "invoices/pdf",
    #             layout: "pdf",
    #             page_size: "a4",
    #             # save_to_file: 'C:\Users\Public\Downloads\invoice.pdf',
    #             save_to_file: file_path,
    #             save_only: true
    #     end
    #     send_file file_path, filename: "invoice_#{@invoice.invoice_number}_#{@invoice.project.project_name}.pdf"
    #   }
    # end
  end

  def export_email
    # deliver_email(@invoice)
    # respond_to do |format|
    #   format.js
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quotation
      @quotation = Quotation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quotation_params
      params.require(:quotation).permit(:content, :user_id, :project_id, :is_valid)
    end

    # email deliver
    # def deliver_email(invoice)
    #   filename = "invoice_#{invoice.invoice_number}_#{invoice.project.project_name}.pdf"
    #   file_path = Rails.root.join("public/pdfs", filename)

    #   unless File.exist?(file_path)
    #     pdf = WickedPdf.new.pdf_from_string(
    #                                         render_to_string('layouts/invoice_pdf', layout: "pdf", page_size: "a4")
    #                                       )
    #     File.open(Rails.root.join("public/pdfs", filename), 'wb') do |file|
    #       file << pdf
    #     end
    #   end
    #   InvoiceMailer.export_to_email(invoice).deliver_later
    # end

end
