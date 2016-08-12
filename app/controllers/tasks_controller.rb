class TasksController < ApplicationController
  before_action :set_list
  before_action :set_task, except: [:create]

   def create
     byebug
     task_info = task_params
     task_info[:user_id] = current_user.id
     @task = @list.tasks.create(task_info)
     redirect_to @list
   end

   def destroy
     if @task.destroy
       flash[:success] = "Task was deleted."
     else
       flash[:error] = "Task could not be deleted."
     end
     redirect_to @list
   end

   def complete
     @task.update_attribute(:completed_at, Time.now)
     redirect_to @list, notice: "Task completed"
   end

   private

     def set_list
       @list = List.find(params[:list_id])
     end

     def set_task
       @task = @list.tasks.find(params[:id])
     end

     def task_params
       params[:task].permit(:detail, :user_id)
     end


end
