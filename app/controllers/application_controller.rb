class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  
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

end
