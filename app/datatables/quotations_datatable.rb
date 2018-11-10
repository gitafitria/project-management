class QuotationsDatatable < ApplicationDatatable
  private

    def data
      quotations.map do |quotation|
        # add id to each row using 'DT_RowId'
        {
          "0" => quotation.created_at.strftime("%d %b %Y"),
          "1" => quotation.title,
          "2" => @view.quotation_content(quotation),
          "3" => @view.quotation_project(quotation),
          "4" => @view.quotation_user(quotation),
          "5" => @view.quotation_option_links(quotation),
          "DT_RowId" => "quotation_#{quotation.id}"
          #       td = quotation.content
          # /     td = quotation.user_id
          # /     td = quotation.project_id
          # /     td = quotation.is_valid
        }
      end
    end

    def count
      quotations.count
    end

    def total_entries
      quotation_list.length
    end

    def quotations
      @quotations ||= fetch_quotations
    end

    def quotation_list
      quotation_list = @list
      unless params[:search].blank? or params[:search][:value].blank?
        search_val = "#{params[:search][:value]}".downcase
        search = columns.reject { |c| c.empty? }.join(" like '%#{search_val}%' or ") + " like '%#{search_val}%'"
        quotation_list = @list.where("#{search}")
      end
      quotation_list = quotation_list.order("#{sort_column} #{sort_direction}")
    end

    def fetch_quotations
      quotations = quotation_list.page(page).per_page(per_page)
    end

    def columns
      ["concat(quotations.created_at)", "lower(quotations.content)", "concat(quotations.project_id)", "concat(quotations.user_id)", ""]
    end
end