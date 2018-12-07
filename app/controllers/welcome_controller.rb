class WelcomeController < ActionController::Base
  def index
  end

  def new_quotation
    @quotation = Quotation.new
  end
end
