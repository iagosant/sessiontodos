class ApplicationController < ActionController::Base

  include LoginHelper
  include Pundit
  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_filter -> { flash.now[:notice] = flash[:notice].html_safe if flash[:html_safe] && flash[:notice] }
  # before_filter :get_current_date

  def require_logged_in
    return true if current_user
    redirect_to sessions_path
    return false
  end

  def team_user_create(team_params)
    team_avatar = team_params[:avatar]
    @team = Team.new(team_params)

    @team.save
    u_params = (team_params[:users_attributes]["0"])
    @user = @team.users.build(u_params)

    if @user.save
      @user.set_default_role
      @user.create_all_tasks_list
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_path
    end
  end

  def user_not_authorized
      flash[:alert] = "Access denied."
      redirect_to (request.referrer || root_path)
  end

  # date
  def get_current_date
<<<<<<< HEAD

=======

>>>>>>> c57d74624eb3b9e58fcdf081a8feb003b8078422
    if (params[:date].blank?) && (@current_date.nil?)
      @current_date =  Date.today
    else
      @current_date = (params[:date].present?) ? params[:date].to_date : @current_date
    end

  end



end
