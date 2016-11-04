class List < ActiveRecord::Base

  attr_accessor :num_incompleted_tasks
  has_attached_file :avatar,
  styles: { :medium => "200x200>", :thumb => "100x100>" }
  validates_attachment_content_type :avatar, :content_type => /^image\/(png|gif|jpeg|jpg)/

  belongs_to :owner, class_name:"User", foreign_key:"user_id"
  has_many :tasks
  has_many :users, through: :tasks

  has_many :collaborations
  has_many :collaboration_users, through: :collaborations, :source => :user

  has_many :invitations, dependent: :destroy

  def collaborations?
    !self.collaborations.blank?
  end

end
