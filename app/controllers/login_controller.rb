class LoginController < ApplicationController
  include LoginHelper
  def new
    @token = params[:invitation_token]
  end

  def create
      user = User.find_by_email(params[:session][:email].downcase)
      # If the user exists AND the password entered is correct.
      if user && user.authenticate(params[:session][:password]) && user.activated
        # Save the user id inside the browser cookie. This is how we keep the user
        # logged in when they navigate around our website.
        @token = params[:invitation_token]
        @invitation = Invitation.find_by_token(@token)
        if (!@token.nil?)&&(user.email==@invitation.recipient_email)
            user.collaboration_lists << List.find(@invitation.list_id) #add this user to the list as a collaborator
        end
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
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
