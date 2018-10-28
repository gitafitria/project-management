class InvoicesDatatable < ApplicationDatatable
  private

    def data
      invoices.map do |invoice|
        # add id to each row using 'DT_RowId'
        {
          "0" => invoice.created_at.strftime("%d %b %Y"),
          "1" => invoice.invoice_number,
          "2" => invoice.project.project_name,
          "3" => invoice.status,
          "4" => @view.invoice_option_links(invoice),
          "DT_RowId" => "invoice_#{invoice.id}"
        }
      end
    end

    def count
      invoices.count
    end

    def total_entries
      invoice_list.length
    end

    def invoices
      @invoices ||= fetch_invoices
    end

    def invoice_list
      invoice_list = @list
      unless params[:search].blank? or params[:search][:value].blank?
        search_val = "#{params[:search][:value]}".downcase
        search = columns.reject { |c| c.empty? }.join(" like '%#{search_val}%' or ") + " like '%#{search_val}%'"
        invoice_list = @list.where("#{search}")
      end
      invoice_list = invoice_list.order("#{sort_column} #{sort_direction}")
    end

    def fetch_invoices
      invoices = invoice_list.page(page).per_page(per_page)
    end

    def columns
      ["concat(invoices.created_at)", "lower(invoices.invoice_number)", "concat(invoices.project_id)", "concat(invoices.status)", ""]
    end
end