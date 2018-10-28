module ProjectsHelper
  def project_show_link(project)
    link_to "Show", project, class: "btn btn-link"
  end

  def project_edit_link(project)
    link_to 'Edit', edit_project_path(project), data: {turbolinks: false}, class: "btn btn-link"
  end

  def project_delete_link(project)
    link_to 'Destroy', project, method: :delete, data: { confirm: 'Are you sure?' }
  end

  def project_option_links(project)
    project_show_link(project) + project_edit_link(project) + project_delete_link(project)
  # o 'Show', project
  #     /       = " | "
  #     /       = link_to 'Edit', edit_project_path(project), data: {turbolinks: false}
  #     /       = " | "
  #     /       = link_t
  end
end
