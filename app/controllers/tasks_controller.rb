class TasksController < ApplicationController
  include TasksHelper
  before_action :set_list, only: [:new, :create, :edit ], if: -> { params[:type].blank? }
  before_action :set_task, except: [:new, :create]
  skip_before_filter :verify_authenticity_token

#   def add_deadline
# byebug
#   end

  def new
    if params[:type]== 'blocker'
       @task = Task.find(params[:task_id])
       @blockers = @task.t_blockers
       @blocker = @task.t_blockers.new
     end
  end

  def create
     task_info = task_params
     task_info[:user_id] = current_user.id

     if params[:type].present?
       @task = Task.find(params[:task_id])
       @list = List.find(@task.list_id)
       @blocker = @task.t_blockers.create(task_params)
     else
       @task = @list.tasks.create(task_info)
     end

     respond_to do |format|
       format.html{ redirect_to @list}
       format.js { render "create", :locals => {:type => params[:type]} }
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
           Task.reset_pk_sequence
         end
     end

   end

   def complete
     @task.update_attribute(:completed_at, Time.now)
     respond_to do |format|
       format.html {  redirect_to @list, notice: "Task completed" }
       format.js
     end

   end

   def changelist

     @task.update_attribute(:list_id, params[:list_id])
     respond_to do |format|
       format.html {  redirect_to @list, notice: "Task changed" }
       format.js
     end

   end

   private

     def set_list

       @list = List.find(params[:list_id])

     end

     def set_task

       @task = Task.find(params[:id])

     end

    #  def set_task(id)
    #    byebug
    #    @task = Task.find(id)
     #
    #  end


     def task_params
       if params[:type].present?
          params[:blocker].permit(:detail, :user_id)
        else
          params[:task].permit(:detail, :user_id)
       end
     end




end
