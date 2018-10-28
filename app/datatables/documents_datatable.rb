class DocumentsDatatable < ApplicationDatatable
  private

    def data
      documents.map do |document|
        # add id to each row using 'DT_RowId'
        {
          "0" => document.created_at.strftime("%d %b %Y"),
          "1" => document.document_name,
          "2" => document.project.project_name,
          "3" => @view.document_option_links(document),
          "DT_RowId" => "document_#{document.id}"
        }
      end
    end

    def count
      documents.count
    end

    def total_entries
      document_list.length
    end

    def documents
      @documents ||= fetch_documents
    end

    def document_list
      document_list = @list
      unless params[:search].blank? or params[:search][:value].blank?
        search_val = "#{params[:search][:value]}".downcase
        search = columns.reject { |c| c.empty? }.join(" like '%#{search_val}%' or ") + " like '%#{search_val}%'"
        document_list = @list.where("#{search}")
      end
      document_list = document_list.order("#{sort_column} #{sort_direction}")
    end

    def fetch_documents
      documents = document_list.page(page).per_page(per_page)
    end

    def columns
      ["concat(documents.created_at)", "lower(documents.document_name)", "concat(documents.project_id)", ""]
    end
end