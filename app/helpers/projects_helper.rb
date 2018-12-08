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
    links = ""
    if policy(project).show?
        links = links + project_show_link(project)
    end
    if policy(project).edit?
        links = links + project_edit_link(project)
    end
    if policy(project).destroy?
        links = links + project_delete_link(project)
    end
    links
    # project_show_link(project) + project_edit_link(project) + project_delete_link(project)
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

  def project_orders_chart_data_this_year
    today = Date.today
    year = today.year
    orders_by_year = Project.total_grouped_by_month_this_year
    data = []

    (1..today.month.to_i).each do |month|
      bulan = get_month_by_int(month)
      month_data = { month_name: bulan, total: orders_by_year[month.to_s]}

      data.push(month_data)
    end

    data.to_json
  end

  def project_orders_chart_data_this_year_by_user(user_id)
    today = Date.today
    year = today.year
    orders_by_year = Project.total_grouped_by_month_this_year(user_id)
    data = []

    (1..today.month.to_i).each do |month|
      bulan = get_month_by_int(month)
      month_data = { month_name: bulan, total: orders_by_year[month.to_s]}

      data.push(month_data)
    end

    data.to_json
  end
end
