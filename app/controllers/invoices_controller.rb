class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy, :pdf, :export_email]
  layout :set_layout

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.all
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def pdf
    respond_to do |format|
      # format.html { render pdf: "invoices/pdf", layout: "pdf", page_size: "a4" }
      format.html {
        render pdf: "invoices/pdf", 
              layout: "pdf",
              page_size: "a4",
              # save_to_file: 'C:\Users\Public\Downloads\invoice.pdf',
              save_to_file: Rails.root.join("public/pdfs", "invoice_#{@invoice.id}.pdf"),
              save_only: true
        send_file Rails.root.join("public/pdfs", "invoice_#{@invoice.id}.pdf"), filename: "invoice_#{@invoice.invoice_number}_#{@invoice.project.project_name}.pdf"
      }
    end
  end

  def export_email
    InvoiceMailer.export_to_email(@invoice).deliver

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
        :recipient,
        :status,
        :tax,
        :total_payment,
        :is_valid,
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
end
