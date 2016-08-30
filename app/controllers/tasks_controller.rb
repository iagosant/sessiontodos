class TasksController < ApplicationController
  before_action :set_list, only: [:new, :create, :edit ]
  before_action :set_task, except: [:create]

  def new
    if params[:type]== 'blocker'
        @blocker = @task.t_blockers.new()
    end
  end
   def create

     task_info = task_params
     task_info[:user_id] = current_user.id
     if params[:type]== 'blocker'
       task_info[:parent_task_id] = params[:task_id]
       @blocker = @task.t_blockers.create(task_info)
     else
       @task = @list.tasks.create(task_info)

     end

     respond_to do |format|
       format.html{ redirect_to @list }
       format.js
    end
   end

   def update
    @task.update_attributes!(task_params)
    respond_to do |format|
      format.html { redirect_to @list }
      format.js
    end
  end

   def destroy

     if (@task.destroy)
         respond_to do |format|
           format.html { redirect_to @list }
           format.js
         end
     end

   end

   def complete

     @task.update_attribute(:completed_at, Time.now)
    #  @task.complete = true
     respond_to do |format|
       format.html {  redirect_to @list, notice: "Task completed" }
       format.js
     end

   end

   private

     def set_list

       @list = List.find(params[:list_id])

     end

     def set_task

       @task = Task.find(params[:id])
      #  if params[:type]== 'blocker'
      #      @t_blocker = @list.tasks.find(params[:task_id])
      #   else
      #      @task = @list.tasks.find(params[:id])
      #      @t_blockers = Task.find_by(parent_task_id:params[:id])
      #   end
     end

     def task_params
       params[:task].permit(:detail, :user_id)
     end


end
