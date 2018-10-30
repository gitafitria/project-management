class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy, :pdf, :export_email]

  has_scope :by_projects, type: :array
  has_scope :by_creators, type: :array

  respond_to :html, :js, :json

  # GET /documents
  # GET /documents.json
  def index
    @documents = apply_scopes(Document).all
    respond_with do |format|
      format.html
      format.json { render json: DocumentsDatatable.new(view_context, @documents) }
      format.js
    end

  end

  # GET /documents/1
  # GET /documents/1.json
  def show
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(document_params)

    respond_to do |format|
      if @document.save
        flash_label = "Document was successfully created."
        flash.now[:notice] = flash_label

        format.html { redirect_to @document, notice: flash_label }
        format.json { render :show, status: :created, location: @document }
        format.js
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        flash_label = "Document was successfully updated."
        flash.now[:notice] = flash_label

        format.html { redirect_to @document, notice: flash_label }
        format.json { render :show, status: :ok, location: @document }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @document.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def pdf
    filename = "#{@document.document_name}.#{@document.doc_file.file.extension.downcase}"

    respond_to do |format|
      # format.html { render pdf: "invoices/pdf", layout: "pdf", page_size: "a4" }
      format.html {
        send_file Rails.root.join("public/", @document.doc_file.path), filename: filename
      }
      format.js {
        send_file Rails.root.join("public/", @document.doc_file.path), filename: filename
      }
    end
  end

  def export_email
    deliver_email(@document)
    respond_to do |format|
      format.js
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(
        :document_name,
        :project_id,
        :user_id,
        :doc_file,
        :is_valid
      )
    end

    def deliver_email(document)
      DocumentMailer.export_to_email(document).deliver_later
    end
end
