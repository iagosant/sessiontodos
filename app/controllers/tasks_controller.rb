class TasksController < ApplicationController
  include TasksHelper
  before_action :set_list, only: [:new, :create, :edit ], if: -> { params[:type].blank? }
  before_action :set_task,  if: -> { !params[:type].blank? || !params[:id].blank? }

  skip_before_filter :verify_authenticity_token

#   def add_deadline
# byebug
#   end
  def index
    respond_to do |format|
      format.html { redirect_to @list  }
      format.js
    end
  end

  def new

  end

  def create
    byebug
     task_info = task_params
     task_info[:user_id] = current_user.id

     if params[:type].present?
       @task = Task.find(params[:task_id])
       @list = List.find(@task.list_id)
       byebug
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
       byebug
       id = (params[:type]== 'blocker') ? params[:task_id] : params[:id]
       @task= Task.find(id)
       @blockers = @task.t_blockers
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
