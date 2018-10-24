class InvoiceMailer < ApplicationMailer
  default from: "info@gitafitria.com"

  def export_to_email(invoice)
    @invoice = invoice
    filename = "invoice_#{@invoice.invoice_number}_#{@invoice.project.project_name}.pdf"
    # attachments[filename] = File.read(Rails.root.join("public/pdfs", "invoice.pdf"), mode: 'rb')
    attachments[filename] = File.open(Rails.root.join("public/pdfs", "invoice_##{@invoice.invoice_number}.pdf"), 'rb') {|f| f.read}
    # attachments[filename] = File.open(Rails.root.join("public/pdfs", "invoice.pdf"), 'rb') {|f| f.read}
    # attachments content_type: "application/pdf", 
    #             body: File.read(Rails.root.join("public/pdfs", "invoice.pdf")), 
    #             filename: filename

    mail to: User.first.email, 
        subject: "SIPM: Invoice ##{@invoice.invoice_number} #{@invoice.project.project_name}"
  
  end
end
