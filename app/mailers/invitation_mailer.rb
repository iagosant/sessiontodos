class InvitationMailer < ApplicationMailer
  default from: 'standupsessionsapp@gmail.com'

  def send_invitation(invitation, signup_url)
    subject    'Invitation'
    recipients invitation.recipient_email
    body       :invitation => invitation, :signup_url => signup_url
    invitation.update_attribute(:sent_at, Time.now)
  end

  def send_notification(invitation, signup_url)
    subject    'Invitation'
    recipients invitation.recipient_email
    body       :invitation => invitation, :signup_url => signup_url
    invitation.update_attribute(:sent_at, Time.now)
  end

end
