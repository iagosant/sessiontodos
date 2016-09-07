module ApplicationHelper

  def get_user_first_names(users)
    first_names = []
    users.each do |user|
      first_names << user.first_name
    end
    first_names
  end

  def set_date
    if (params[:date].blank?) && (get_date.nil?)
      $date =  Date.today
    else
      $date = (params[:date].present?)? params[:date].to_date : $date
    end
  end

  def get_date
    @get_date = $date
  end

end
