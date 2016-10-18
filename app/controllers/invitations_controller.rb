class InvitationsController < ApplicationController
  before_action :set_list

  def index
    @invitations = Invitation.all
  end

  def show
  end

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.sender = current_user

    respond_to do |format|
      if @invitation.save
        @url = @invitation.recipient != nil ? login_url(:invitation_token => @invitation.token) : sign_up_path(:invitation_token => @invitation.token)
        InvitationMailer.send_invitation(@invitation, @url).deliver_now #send the invite data to our mailer to deliver the email
          format.html { redirect_to lists_path, notice: "Thank you, invitation sent."}
          format.json { }
      else
        format.html { redirect_to lists_path, notice: "Thank you, we will notify when we are ready."}
        format.json { }
      end
    end
  end

  def edit
    @invitation = Invitation.find_by_token(token)
    if @invitation.sender
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
    def set_list
      @list= List.find(params[:list_id])
    end

    def invitation_params
      params.require(:invitation).permit(:sender_id, :list_id, :recipient_email, :token, :sent_at)
    end
end
