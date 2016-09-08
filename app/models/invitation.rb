class Invitation < ActiveRecord::Base
  attr_accessible :sender_id, :list_id, :recipient_email, :token, :sent_at

  belongs_to :list
  has_one :recipient, :class_name => 'User'
end
