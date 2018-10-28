module InvoicesHelper
  def invoice_show_link(invoice)
    link_to "Show", invoice, class: "btn btn-link"
  end

  def invoice_edit_link(invoice)
    link_to 'Edit', edit_invoice_path(invoice), data: {turbolinks: false}, class: "btn btn-link"
  end

  def invoice_export_link(invoice)
    link_to 'Export', "#", class: "invoice-export-link btn btn-link", data: {invoice: invoice, pdf_url: download_invoice_pdf_path(invoice), email_url: download_invoice_email_path(invoice)}
  end

  def invoice_option_links(invoice)
    invoice_show_link(invoice) + invoice_edit_link(invoice) + invoice_export_link(invoice)
  end  
end