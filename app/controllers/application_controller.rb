class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  include Pundit
  protect_from_forgery

  def render_pdf
    render pdf: "#{controller_name}/#{action_name}",
           layout: "pdf",
           page_size: "a4"
  end

  def set_layout
    if action_name == "pdf"
      "pdf"
    end
  end

  protected
    def after_sign_in_path_for(resource)
      dashboard_path || root_path
    end

  private
    def user_not_authorized
      flash[:error] = "You are not authorized to perform this action."
      redirect_to request.referrer || root_path, alert: "You are not authorized to perform this action."
    end

end
