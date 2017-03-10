class TaskBroadcastJob < ApplicationJob
  queue_as :default

  def perform(task)
    ActionCable.server.broadcast "list_channel", { task: render_task(task),user: task.user_id, task_id: task.id }

  end

  private

  def render_task(task)
    TasksController.render(partial: 'tasks/incompleted', locals: {task: task }).squish
  end
end
