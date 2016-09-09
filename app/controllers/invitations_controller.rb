class InvitationsController < ApplicationController
  # before_action :set_invitation, only: [:show, :edit, :update, :destroy]

  # GET /invitations
  # GET /invitations.json
  def index
    @invitations = Invitation.all
  end

  # GET /invitations/1
  # GET /invitations/1.json
  def show
  end

  # GET /invitations/new
  def new
    @invitation = Invitation.new
  end

  def create
    byebug
    @invitation = Invitation.new(invitation_params)
    @invitation.sender = current_user

    byebug
    if @invitation.save
      if logged_in?
        InviteMailer.send_invitation(@invitation, new_user_path(:invitation_token => @invitation.token)).deliver #send the invite data to our mailer to deliver the email
      
        flash[:notice] = "Thank you, invitation sent."
        redirect_to @list
      else
        flash[:notice] = "Thank you, we will notify when we are ready."
        redirect_to root_url
      end
    else
      render :action => 'new'
    end
  end

  def edit
    byebug

    @invitation = Invitation.find_by_token(token)
    if @invitation.sender

    byebug
    if @invitation.save
      if logged_in?
        Mailer.deliver_invitation(@invitation, signup_url(@invitation.token))
        flash[:notice] = "Thank you, invitation sent."
        redirect_to @list
      else
        flash[:notice] = "Thank you, we will notify when we are ready."
        redirect_to root_url
      end
    else
      render :action => 'new'
    end
  end


  # PATCH/PUT /invitations/1
  # PATCH/PUT /invitations/1.json
  # def update
  #   respond_to do |format|
  #     if @invitation.update(invitation_params)
  #       format.html { redirect_to @invitation, notice: 'Invitation was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @invitation }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @invitation.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to invitations_url, notice: 'Invitation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_invitation
    #   @invitation = Invitation.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params
      params.require(:invitation).permit(:sender_id, :list_id, :recipient_email, :token, :sent_at)
    end
end
