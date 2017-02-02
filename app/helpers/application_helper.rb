module ApplicationHelper

  def get_user_first_names(users)
    first_names = []
    users.each do |user|
      first_names << user.first_name
    end
    first_names
  end

  def is_today?(date)
    (date == Date.today)
  end

  def today(date)
    (is_today?(date))? 'today' : 'before'
  end
  # date
  def get_current_date

    if (params[:date].blank?) && (@current_date.nil?)
      @current_date =  Date.today
    else
      @current_date = (params[:date].present?) ? params[:date].to_date : @current_date
    end

  end
  # def is_active_controller(controller_name)
  #     params[:controller] == controller_name ? "active" : nil
  # end
  #
  # def is_active_action(action_name)
  #     params[:action] == action_name ? "active" : nil
  # end

end
