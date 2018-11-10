class QuotationMailer < ApplicationMailer
  default from: "info@gitafitria.com"

  def export_to_email(quotation, receiver)
    @quotation = quotation
    filename = "quotation_#{@quotation.title}.pdf"
    # attachments[filename] = File.read(Rails.root.join("public/pdfs", "invoice.pdf"), mode: 'rb')
    attachments[filename] = File.open(Rails.root.join("public/pdfs/quotations/", filename), 'rb') {|f| f.read}

    mail to: receiver,
        subject: "SIPM: Quotation ##{@quotation.id} #{@quotation.title}"

  end
end
