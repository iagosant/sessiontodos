module LoginHelper

  def log_in(user)
    session[:user_id] = user.id
    all_task_list = current_user.created_lists.find_by(name: 'All Tasks')
    all_task_list = (all_task_list.nil?) ? current_user.created_lists.create(name: "All Tasks") : all_task_list
    session[:all_tasks_id] = all_task_list.id
    # session[:team_id] = user.team_id
  end

  def current_user
    # if (user_id = session[:user_id])
    #   @current_user ||= User.find_by(id: user_id)
    #
    # end
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def current_all_lists
      @lists = current_user.created_lists.all.order('created_at')
      @collaboration_lists = current_user.collaboration_lists.all
      @current_all_lists ||= @lists + @collaboration_lists
  end

  def current_all_tasks
    if (all_tasks_id = session[:all_tasks_id])
      @current_all_tasks ||= List.find_by(id: all_tasks_id)
    end
  end

  def current_team
    if (team_id = session[:team_id])
      @current_team ||= Team.find_by(id: team_id)
    end
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    # sessions.delete(:team_id)
    @current_user = nil
    # @current_team = nil

  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

end
