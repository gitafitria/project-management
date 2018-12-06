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

  def months
    months = {}
    months["1"] = {short: "Jan", long: "Januari"}
    months["2"] = {short: "Feb", long: "Februari"}
    months["3"] = {short: "Mar", long: "March"}
    months["4"] = {short: "Apr", long: "April"}
    months["5"] = {short: "May", long: "May"}
    months["6"] = {short: "Jun", long: "June"}
    months["7"] = {short: "Jul", long: "July"}
    months["8"] = {short: "Aug", long: "August"}
    months["9"] = {short: "Sep", long: "September"}
    months["10"] = {short: "Oct", long: "October"}
    months["11"] = {short: "Nov", long: "November"}
    months["12"] = {short: "Dec", long: "December"}

    months
  end

  def get_month_by_int(num = 1, option = 'short')
    months[num.to_s][option.to_sym]
  end
end
