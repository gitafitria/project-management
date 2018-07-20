module ApplicationHelper
  def active_controller(controllers) # 'vetlabs#index' or ['vetlabs#index', 'vetlabs#new']
    if controllers.class == String
      active_pages = controllers.split("#")
      if active_pages.size > 1
        return 'active' if controller_name == active_pages[0] and action_name == active_pages[1]
      else
        return 'active' if controller_name == active_pages[0]
      end
    elsif controllers.class == Array
      controllers.each do |s|
        x = active_controller s
        return 'active' if x == 'active'
      end
    end
  end

end
