module ProjectsHelper
  def project_show_link(project)
    link_to "Show", project, class: "btn btn-link"
  end

  def project_edit_link(project)
    link_to 'Edit', edit_project_path(project), data: {turbolinks: false}, class: "btn btn-link"
  end

  def project_delete_link(project)
    link_to 'Destroy', project, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-link"
  end

  def project_option_links(project)
    project_show_link(project) + project_edit_link(project) + project_delete_link(project)
  end

  def project_created_by(project)
    if project.new_record?
      return current_user
    else
      return project.user
    end
  end

  def project_user_name(project)
    user = project_created_by(project)
    fullname(user)
  end
end
