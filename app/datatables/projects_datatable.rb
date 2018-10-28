class ProjectsDatatable < ApplicationDatatable
  private

    def data
      projects.map do |project|
        # add id to each row using 'DT_RowId'
        {
          "0" => project.project_name,
          "1" => project.created_at.strftime("%d %b %Y"),
          "2" => project.status,
          "3" => @view.project_option_links(project),
          "DT_RowId" => "project_#{project.id}"
        }
      end
    end

    def count
      projects.count
    end

    def total_entries
      project_list.length
    end

    def projects
      @projects ||= fetch_projects
    end

    def project_list
      project_list = @list
      unless params[:search].blank? or params[:search][:value].blank?
        search_val = "#{params[:search][:value]}".downcase
        search = columns.reject { |c| c.empty? }.join(" like '%#{search_val}%' or ") + " like '%#{search_val}%'"
        project_list = @list.where("#{search}")
      end
      project_list = project_list.order("#{sort_column} #{sort_direction}")
    end

    def fetch_projects
      projects = project_list.page(page).per_page(per_page)
    end

    def columns
      ["lower(projects.project_name)", "concat(projects.created_at)", "concat(projects.status)", ""]
    end
end