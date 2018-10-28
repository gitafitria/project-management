class DocumentMailer < ApplicationMailer
  default from: "info@gitafitria.com"

  def export_to_email(document)
    @document = document
    filename = "#{@document.document_name}.#{@document.doc_file.file.extension.downcase}"
    # attachments[filename] = File.read(Rails.root.join("public/pdfs", "document.pdf"), mode: 'rb')
    attachments[filename] = File.open(Rails.root.join("public/", @document.doc_file.path), 'rb') {|f| f.read}

    mail to: User.first.email,
        subject: "SIPM: Document #{@document.document_name} - #{@document.project.project_name}"

  end
end
