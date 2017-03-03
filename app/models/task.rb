class Task < ApplicationRecord
  attr_accessor :t_blocker_attributes, :completed
  belongs_to :list
  belongs_to :user
  belongs_to :assigner_user, class_name: "User"
  has_many :t_blockers, class_name: "Task", foreign_key: "parent_task_id"
  accepts_nested_attributes_for :t_blockers

  def completed?
    # byebug
    !completed_at.blank?
  end

  def important?
    flag
  end

  def deadline?
    !deadline.blank?
  end

  def list_belonging
    @list_belonging = List.find(self.list_id).name
  end

  def is_blocker?
    !self.parent_task_id.blank?
  end
end
