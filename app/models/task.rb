class Task < ApplicationRecord
  attr_accessor :t_blocker_attributes, :completed
  belongs_to :list
  belongs_to :user
  belongs_to :assigner_user, class_name: "User"
  has_many :t_blockers, class_name: "Task", foreign_key: "parent_task_id"
  accepts_nested_attributes_for :t_blockers
  # after_save :broadcast_save
  after_destroy :broadcast_delete
  after_commit :broadcast_save
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

  def broadcast_delete
   ActionCable.server.broadcast 'list_channel', status: 'deleted', id: id, user: user_id, list_id: list_id

 end

 def broadcast_save
   status = (self.completed?) ? 'completed' : 'saved'
   partial = (self.completed?) ? 'completed' : 'incompleted'
   ActionCable.server.broadcast "list_channel", { html: render_task(self,partial),user: self.user_id, id: self.id, status: status,list_id: self.list_id, completed: self.completed?, partial: partial }
 end

 private

 def render_task(task,partial)

    TasksController.render(partial: "tasks/#{partial}", locals: {task: task}).squish
 end

end
