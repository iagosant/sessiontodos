class LoginController < ApplicationController
  include LoginHelper
  def new

  end

  def create
      user = User.find_by_email(params[:session][:email].downcase)
      # If the user exists AND the password entered is correct.
      if user && user.authenticate(params[:session][:password]) && user.activated
        # Save the user id inside the browser cookie. This is how we keep the user
        # logged in when they navigate around our website.
        log_in user
        remember user
        redirect_to '/lists'
      else
      # If user's login doesn't work, send them back to the login form.
        flash.now[:danger] = 'Invalid email/password combination'
        render 'new'
        # redirect_to '/login'
      end
    end

    def destroy
      # session[:user_id] = nil
      # redirect_to '/login'
      log_out if logged_in?
      redirect_to root_url
    end


  end
