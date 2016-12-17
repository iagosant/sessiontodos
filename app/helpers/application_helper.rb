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

end
