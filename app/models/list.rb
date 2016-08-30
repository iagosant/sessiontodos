class List < ActiveRecord::Base
  belongs_to :owner, class_name:"User", foreign_key:"user_id"

  has_many :tasks

  has_many :collaborations
  has_many :collaboration_users, through: :collaborations, :source => :user

  # def completed_tasks
  #    tasks.where.not(completed_at: nil).order("updated_at DESC")
  # end
end
