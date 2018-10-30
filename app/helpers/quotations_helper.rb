module QuotationsHelper
  def quotation_show_link(quotation)
    link_to "Show", quotation, class: "btn btn-link"
  end

  def quotation_edit_link(quotation)
    link_to 'Edit', edit_quotation_path(quotation), data: {turbolinks: false}, class: "btn btn-link"
  end

  def quotation_export_link(quotation)
    link_to 'Export', "#", class: "quotation-export-link btn btn-link", data: {quotation: quotation, pdf_url: download_quotation_pdf_path(quotation), email_url: download_quotation_email_path(quotation)}
  end

  def quotation_option_links(quotation)
    quotation_show_link(quotation) + quotation_edit_link(quotation) + quotation_export_link(quotation)
  end

  def quotation_project(quotation)
    unless quotation.project.nil?
      return quotation.project.project_name
    end
    return nil
  end

  def quotation_user(quotation)
    # @view.fullname(quotation.user) rescue nil
    unless quotation.user.nil?
      return fullname(quotation.user)
    end
    return nil
  end

  def quotation_content(quotation)
    return "#{h raw truncate(quotation.content, :length => 30)}"

  end
end
