module DocumentsHelper
  def document_show_link(document)
    link_to "Show", document, class: "btn btn-link", data: {turbolinks: false}
  end

  def document_edit_link(document)
    link_to 'Edit', edit_document_path(document), data: {turbolinks: false}, class: "btn btn-link"
  end

  def document_export_link(document, class_optional = "")
    class_optional = "btn btn-link" if class_optional.blank?
    link_to 'Export', "#", class: "document-export-link #{class_optional}", data: {document: document, pdf_url: download_document_pdf_path(document), email_url: download_document_email_path(document)}
  end

  def document_option_links(document)
    document_show_link(document) + document_edit_link(document) + document_export_link(document)
  end
end
