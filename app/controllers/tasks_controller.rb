class TasksController < ApplicationController
  include TasksHelper
  before_action :require_logged_in
  before_action :set_list, only: [:new, :create, :edit, :complete ], if: -> { params[:type].blank? }
  before_action :set_task,  if: -> { !params[:type].blank? || !params[:id].blank? }
  before_action :set_user, only: [:create, :index ]
  skip_before_filter :verify_authenticity_token

  def index
    if (params[:type].present? || params[:type]=="blocker")
       @t_blockers = @task.t_blockers
    end
    respond_to do |format|
      format.html { redirect_to @list  }
      format.js
    end
  end

  def new
    if (params[:type].present? || params[:type]=="blocker")
       @t_blocker = @task.t_blockers.new
     else
       @task = Task.new
    end
     render layout: 'modal'
    # respond_to do |format|
    #   format.html { redirect_to @list  }
    #   format.js
    # end
  end

  def edit
    # if (params[:type].present? || params[:type]=="blocker")
    #    render partial: "edit_form_t_blocker"
    # else
      render layout: 'modal'
    # end
  end

  def create
    task_info = task_params
    if params[:type].present?
       @t_blocker = @task.t_blockers.create(task_params)
     else
       @task = @list.tasks.create(task_params)
     end
     respond_to do |format|
       format.html{ redirect_to @list, :locals => {:task => @task}}
       format.js {  }
     end
  end

  def update
    @task.update_attributes!(task_params)
    respond_to do |format|
      format.html { redirect_to @list}
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

     def set_user
      @user = User.find((!task_params[:user_id].blank?) ? task_params[:user_id] : current_user.id)
     end

     def set_task
       if (params[:id].blank?) && (params[:type]== 'blocker')
          @task= Task.find(params[:task_id])
        else
          @task= Task.find(params[:id])
        end

     end

     def task_params
        params.require(:task).permit(:detail, :user_id, :assigner_id)
     end
end
