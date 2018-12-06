class DashboardController < ApplicationController
  def index
    today = Date.today
    @projects = Project.where(is_valid: true).where(created_at: today.beginning_of_year..today)
    @invoices = Invoice.where(is_valid: true)
  end

end
