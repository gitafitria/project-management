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
    links = ""
    if policy(invoice).show?
        links = links + invoice_show_link(invoice)
    end
    if policy(invoice).edit?
        links = links + invoice_edit_link(invoice)
    end
    if policy(invoice).export?
        links = links + invoice_export_link(invoice)
    end
    links

    # invoice_show_link(invoice) + invoice_edit_link(invoice) + invoice_export_link(invoice)
  end

  def invoice_orders_chart_data_per_project_this_year(user_id = nil)
    orders_per_project = Invoice.invoice_orders_chart_data_per_project_this_year(user_id)
    project_ids = orders_per_project.keys

    project = Project.valid.all

    query = ""
    if project_ids.nil?
      query = "id IN (#{project_ids})"
    end

    unless user_id.nil?
      user = User.find(user_id)

      if user.client?
        unless query.blank?
          query = query + " OR "
        end
        query = query + "projects.client_ids @> ARRAY[#{user.id}]"
      end
    end

    project = project.where(query)

    projects_data = {}

    data = []
    project.each do |project|
      invoice_data = { project: project.project_name }
      invoice_data[:total] = orders_per_project[project.id] || 0
      data.push(invoice_data)
    end
    data.to_json
  end
end