module InvoicesHelper
  def invoice_show_link(invoice)
    link_to "Show", invoice, class: "btn btn-link", data: {turbolinks: false}
  end

  def invoice_edit_link(invoice)
    link_to 'Edit', edit_invoice_path(invoice), data: {turbolinks: false}, class: "btn btn-link"
  end

  def invoice_export_link(invoice, class_optional = "")
    class_optional = "btn btn-link" if class_optional.blank?
    link_to 'Export', "#", class: "invoice-export-link #{class_optional}", data: {invoice: invoice, pdf_url: download_invoice_pdf_path(invoice), email_url: download_invoice_email_path(invoice)}
  end

  def invoice_option_links(invoice)
    invoice_show_link(invoice) + invoice_edit_link(invoice) + invoice_export_link(invoice)
  end

  def invoice_orders_chart_data_per_project_this_year
    orders_per_project = Invoice.invoice_orders_chart_data_per_project_this_year
    project_ids = orders_per_project.keys

    project = Project.where("id IN (?)", project_ids)
    projects_data = {}
    project.each { |p| projects_data[p.id] = p.project_name}

    data = []
    orders_per_project.each do |project_id, total|

      invoice_data = { project: projects_data[project_id], total: total}

      data.push(invoice_data)

    end
    data.to_json
  end
end