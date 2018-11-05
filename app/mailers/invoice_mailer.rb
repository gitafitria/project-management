class InvoiceMailer < ApplicationMailer
  default from: "info@gitafitria.com"

  def export_to_email(invoice, receiver)
    @invoice = invoice
    filename = "invoice_#{@invoice.invoice_number}_#{@invoice.project.project_name}.pdf"
    # attachments[filename] = File.read(Rails.root.join("public/pdfs", "invoice.pdf"), mode: 'rb')
    attachments[filename] = File.open(Rails.root.join("public/pdfs", filename), 'rb') {|f| f.read}

    mail to: receiver,
        subject: "SIPM: Invoice ##{@invoice.invoice_number} #{@invoice.project.project_name}"

  end
end
