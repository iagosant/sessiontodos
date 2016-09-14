class List < ActiveRecord::Base

  belongs_to :owner, class_name:"User", foreign_key:"user_id"
  
  has_attached_file :avatar,
  styles: { :medium => "200x200>", :thumb => "100x100>" }
  validates_attachment_content_type :avatar, :content_type => /^image\/(png|gif|jpeg|jpg)/

  has_many :tasks

  has_many :collaborations
  has_many :collaboration_users, through: :collaborations, :source => :user

  has_many :invitations
  # def completed_tasks
  #    tasks.where.not(completed_at: nil).order("updated_at DESC")
  # end

  # def all_tasks?
  #   return (self.all_tasks == true)? true : false
  # end

end
