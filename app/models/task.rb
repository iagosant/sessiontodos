class Task < ActiveRecord::Base
  belongs_to :list
  belongs_to :user
  has_many :blockers, class_name: "Task", foreign_key: "parent_task_id"
end
