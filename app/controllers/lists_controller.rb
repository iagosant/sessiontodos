class ListsController < ApplicationController
  include ApplicationHelper
  before_action :require_logged_in
  helper_method :get_current_date
  before_action :set_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_list, only: [:index, :show, :edit, :update, :destroy, :complete_users]

  def index
    @all_tasks   = current_user.tasks.where(:completed_at => nil).order('created_at')

    @collaborators = @list.collaboration_users
    respond_to do |format|
      format.html
      format.json { render json: @collaborators }
    end
    # respond_to do |format|
    #   format.html
    #   format.json do
    #     render :json => {:tasks => Task.all.map(&:to_json) }
    #   end
    # end
  end

  def show

    # @list = List.find(params[:id])
    # set_task_per_list

  end

  def complete_users

    @collaboration_users = @list.collaboration_users
    @c_users = {}
    @collaboration_users.each do |user|
      @c_users['value'] =   user.id
      @c_users['label'] =   user.first_name
    end
    respond_to do |format|
      format.html {redirect_to lists_url}
      format.json { render json: @c_users }
    end
  end

  def new
    @list = current_user.created_lists.new
  end

  def edit
  end

  def create
    @list = current_user.created_lists.new(list_params)

    respond_to do |format|
      if @list.save
        # @lists = current_user.created_lists.all
        # set_task_per_list
        format.html{ redirect_to lists_url}
        format.js

      end
    end
  end

  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to lists_path }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to lists_path, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
      List.reset_pk_sequence
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      if params[:id].blank?
        @list = current_all_tasks
      else
        @list = List.find(params[:id])
      end
      @lists = current_user.created_lists.all.order('created_at')
      @collaboration_lists = current_user.collaboration_lists.all
      # set_task_per_user

    end

    def set_user
      if params[:user_id].blank?
        @user = current_user
      else
        @user = User.find(params[:user_id])
      end
    end


# <<<<<<< HEAD
    def set_task_per_user

      # set_date
      # d_today = get_current_date
      d_yesterday =  get_current_date - 1.day
      #  @tasks = @list.tasks.where('DATE(created_at) BETWEEN ? AND ?', d_yesterday , @current_date )
      @tasks = @user.tasks.where(:list_id=>@list.id)
      @incomplete_tasks = @tasks.where(["completed_at IS ? and DATE(created_at)=?",nil,@current_date])
      @complete_tasks = @tasks.where('DATE(completed_at) BETWEEN ? AND ?', d_yesterday , @current_date ).order('completed_at')
    end
# =======
#     # def set_task_per_user
#     #   d_today = get_current_date
#     #   d_yesterday =  d_today - 1.day
#     #   incomplete_tasks = @list.incompleted_tasks(@user)
#     #   @incomplete_tasks = incomplete_tasks.where(["DATE(created_at)=?",d_today])
#     #   byebug
#     #   @incomplete_tasks_past= (Date.today == d_today)? incomplete_tasks - @incomplete_tasks : nil
#     #   # @incomplete_tasks_past = incomplete_tasks - @incomplete_tasks
#     #   # @list.incompleted_tasks(@user).where(["DATE(created_at)<?",d_today])
#     #   # @incomplete_tasks = @tasks.where(["completed_at IS ? and DATE(created_at)=?",nil,d_today])
#     #   @complete_tasks = @list.completed_tasks(@user).where('DATE(completed_at) BETWEEN ? AND ?' , d_yesterday , d_today ).order('completed_at')
#     # end
#
# >>>>>>> c57d74624eb3b9e58fcdf081a8feb003b8078422

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:name, :description, :avatar, :date)
    end
end
