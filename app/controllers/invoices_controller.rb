class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy, :pdf, :export_email, :download_pdf]
  layout :set_layout

  has_scope :by_projects, type: :array
  has_scope :by_creators, type: :array
  has_scope :by_recipients, type: :array
  has_scope :by_belongings, type: :array
  has_scope :by_status

  respond_to :html, :js, :json

  # GET /invoices
  # GET /invoices.json
  def index
    require 'will_paginate/array'

    authorize Invoice

    @invoices = apply_scopes(Invoice).valid.all

    if current_user.client?
      @invoices = @invoices.by_belongings([current_user.id])
    end

    respond_with do |format|
      format.html
      format.json { render json: InvoicesDatatable.new(view_context, @invoices) }
      format.js
    end

  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    authorize @invoice
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new

    authorize @user
  end

  # GET /invoices/1/edit
  def edit
    authorize @invoice
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)

    authorize @invoice

    @invoice.status = 'waiting'

    respond_to do |format|
      if @invoice.save
        if issue_date_is_today?(@invoice)
          if deliver_email(@invoice)
            @invoice.update(status: 'sent')
          end
        end
        flash_label = 'Invoice was successfully created.'
        flash.now[:notice] = flash_label

        format.html { redirect_to @invoice, notice: flash_label }
        format.json { render :show, status: :created, location: @invoice }
        format.js
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    authorize @invoice

    @invoice.status = 'sent'

    respond_to do |format|
      if @invoice.update(invoice_params)
        flash_label = 'Invoice was successfully updated.'
        flash.now[:notice] = flash_label

        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    authorize @invoice

    @invoice.is_valid = false
    @invoice.save
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def pdf
    authorize @invoice

    filename = "invoice_#{@invoice.invoice_number}_#{@invoice.project.project_name}.pdf"
    file_path = Rails.root.join("public/pdfs/invoices/", filename)
    flash_label = 'PDF was successfully exported.'
    flash.now[:notice] = flash_label

    respond_to do |format|
      # format.html { render pdf: "invoices/pdf", layout: "pdf", page_size: "a4" }
      format.html {
        unless File.exist?(file_path)
          render pdf: "invoices/pdf",
                layout: "pdf",
                page_size: "a4",
                # save_to_file: 'C:\Users\Public\Downloads\invoice.pdf',
                save_to_file: file_path,
                save_only: true
        end
        send_file file_path, filename: filename
      }
      format.js {
        unless File.exist?(file_path)
          render pdf: "invoices/pdf",
                layout: "pdf",
                page_size: "a4",
                # save_to_file: 'C:\Users\Public\Downloads\invoice.pdf',
                save_to_file: file_path,
                save_only: true
        end
        send_file file_path, filename: filename
      }
    end
  end

  def export_email
    authorize @invoice

    if deliver_email(@invoice, params[:email_sent_to])
      flash_label = 'Emails was successfully sent.'
      flash.now[:notice] = flash_label
    end

    respond_to do |format|
      format.js
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params.require(:invoice).permit(
        :user_id,
        :project_id,
        :invoice_number,
        :issue_date,
        :due_date,
        :subject,
        :status,
        :tax,
        :total_payment,
        :is_valid,
        :is_tax_included,
        recipient_ids: [],
        invoice_items_attributes: [
          :id,
          :description,
          :quantity,
          :unit_price,
          :invoice_id,
          :is_valid,
          :_destroy
        ]
      )
    end

    # email deliver
    def deliver_email(invoice, receivers = nil)
      filename = "invoice_#{invoice.invoice_number}_#{invoice.project.project_name}.pdf"
      file_path = Rails.root.join("public/pdfs/invoices/", filename)

      unless File.exist?(file_path)
        pdf = WickedPdf.new.pdf_from_string(
                render_to_string('layouts/invoice_pdf',
                  layout: "pdf",
                  page_size: "a4"
                )
              )
        File.open(Rails.root.join("public/pdfs/invoices/", filename), 'wb') do |file|
          file << pdf
        end
      end
      if receivers.nil?
        receivers = invoice.project.clients.map{|c| c.email}
      end
      receivers.each do |r|
        InvoiceMailer.export_to_email(invoice, r).deliver_later
      end
    end

    def issue_date_is_today?(invoice)
      invoice.issue_date.today?
    end
end
