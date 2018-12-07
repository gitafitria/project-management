module QuotationsHelper
  def quotation_show_link(quotation)
    link_to "Show", quotation, data: {turbolinks: false}, class: "btn btn-link"
  end

  def quotation_edit_link(quotation)
    link_to 'Edit', edit_quotation_path(quotation), data: {turbolinks: false}, class: "btn btn-link"
  end

  def quotation_export_link(quotation, class_optional = "")
    class_optional = "btn btn-link" if class_optional.blank?

    link_to 'Export', "#", class: "quotation-export-link #{class_optional}", data: {quotation: quotation, pdf_url: download_quotation_pdf_path(quotation), email_url: download_quotation_email_path(quotation)}
  end

  def quotation_option_links(quotation)
    quotation_show_link(quotation) + quotation_edit_link(quotation) + quotation_export_link(quotation)
  end

  def quotation_project(quotation)
    if quotation.project.nil?
      link_to "create as new project", create_project_quotation_path(quotation), data: {turbolinks: false}
    else
      quotation.project.project_name
    end
  end

  def quotation_user(quotation)
    if quotation.user.nil?
      quotation.email
    else
      fullname(quotation.user)
    end
  end

  def quotation_content(quotation)
    raw quotation.content.truncate(30)
  end
end
