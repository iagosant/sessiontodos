module ApplicationHelper

  def get_user_first_names(users)
    first_names = []
    users.each do |user|
      first_names << user.first_name
    end
    first_names
  end

  # def is_today?(date)
  #   (date == Date.today)
  # end

  def today(date)
    (date.today?)? 'today' : 'before'
  end

  def permitted_user?(user_id, current_user, current_list)
    return true if (current_user.id == user_id)|| current_user.owner?(current_list)
  end

  # date

  # def is_active_controller(controller_name)
  #     params[:controller] == controller_name ? "active" : nil
  # end
  #
  # def is_active_action(action_name)
  #     params[:action] == action_name ? "active" : nil
  # end

end
