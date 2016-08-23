class Task < ActiveRecord::Base
  attr_accessor :t_blocker_attributes, :completed
  belongs_to :list
  belongs_to :user
  has_many :t_blockers, class_name: "Task", foreign_key: "parent_task_id"
  accepts_nested_attributes_for :t_blockers

  def completed?
    !completed_at.blank?
  end
end
