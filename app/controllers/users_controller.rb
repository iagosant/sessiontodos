class UsersController < ApplicationController
  include UsersHelper
  include PasswordResetsHelper
  before_action :set_user, only: [:update]
  before_action :require_logged_in, only: [:show, :edit, :update, :destroy]
  attr_accessor :email, :name, :password, :password_confirmation

  def index
    # this_user = User.find(session[:user_id])
    # authorize this_user
    # @team = Team.find(session[:team_id])
    # @users = @team.users.all
  end

  def roleUpdate
    this_user = User.find(session[:user_id])
    authorize this_user
    user_id = params[:user_id]
    new_role = params[:new_role]
    update_this_user = User.find(user_id)
    update_this_user.update(role: new_role)
  end

  def show
    # authorize @user
    #FIX SET USER

    @user = User.find(session[:user_id])
  end

  def new
    # user = User.find(session[:user_id])
    # authorize user
    @user = User.new
    @token = params[:invitation_token]
    if !@token.nil?
      @user.email = Invitation.find_by_token(@token).recipient_email
    end

  end

  def edit
    # authorize @user
    @user = User.find(params[:id])

  end

  def create
    # user = User.find(session[:user_id])
    # authorize user
    # user_info = user_params
    # temp_password = SecureRandom.hex(8)
    # user_info[:password] = temp_password
    # user_info[:password_confirmation] = temp_password
    # @team = Team.find(session[:team_id])
    @user = User.create(user_params)
    @token = params[:invitation_token]
    byebug
    if @user.save
      if !@token.nil?
          list = Invitation.find_by_token(@token).list_id #find the list_id attached to the invitation
          @user.collaboration_lists << List.find(list) #add this user to the list as a collaborator
      end
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to login_path
    end
  end

  def update
<<<<<<< HEAD
    current_user.current_step = (user_params[:current_step].present?)? user_params[:current_step] : steps.first
    if current_user.current_step == "security"
      update_password(user_params)
    else
    end
=======
    byebug
    current_user.current_step = (user_params[:current_step].present?)? user_params[:current_step] : steps.first
>>>>>>> d1f9dfbf4ca487d1af56e9f8afb024e15af40365
    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to :back, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @current_user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
      User.reset_pk_sequence
    end
  end

  def accept_invitation
    # invitation.token if invitation
  end

  def resend_activation
    @user = User.find_by(email:params[:email])
    @user.activation_token = User.new_token
    UserMailer.account_activation(@user).deliver_now
    flash[:info] = "Please check your email to activate your account."
    redirect_to new_password_reset_url
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not cool enough to do this - go back from whence you came."
    redirect_to(sessions_path)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by(session[:user_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :avatar, :email, :password, :password_confirmation, :role, :current_step)
  end
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
end
