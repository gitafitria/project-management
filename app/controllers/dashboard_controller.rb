class DashboardController < ApplicationController
  def index
    today = Date.today
    end_of_today = today.end_of_day
    @projects = Project.valid.where(created_at: today.beginning_of_year..end_of_today)
    @invoices = Invoice.valid.where(created_at: today.beginning_of_year..end_of_today)
  end

end
