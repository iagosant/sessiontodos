class ListsController < ApplicationController
  include ApplicationHelper
  helper_method :get_current_date
  before_action :set_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_list, only: [:index, :show, :edit, :update, :destroy]
  before_action :require_logged_in

  def index
    @all_tasks   = current_user.tasks.where(:completed_at => nil).order('created_at')
    @lists = current_user.created_lists.all.order('created_at')
    @collaboration_lists = current_user.collaboration_lists.all
    # respond_to do |format|
    #   format.html
    #   format.json do
    #     render :json => {:tasks => Task.all.map(&:to_json) }
    #   end
    # end
  end

  def show
    # byebug
    # @list = List.find(params[:id])
    # set_task_per_list

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
      # set_task_per_user

    end

    def set_user
      if params[:user_id].blank?
        @user = current_user
      else
        @user = User.find(params[:user_id])
      end
    end


    # def set_task_per_user
    #   d_today = get_current_date
    #   d_yesterday =  d_today - 1.day
    #   incomplete_tasks = @list.incompleted_tasks(@user)
    #   @incomplete_tasks = incomplete_tasks.where(["DATE(created_at)=?",d_today])
    #   byebug
    #   @incomplete_tasks_past= (Date.today == d_today)? incomplete_tasks - @incomplete_tasks : nil
    #   # @incomplete_tasks_past = incomplete_tasks - @incomplete_tasks
    #   # @list.incompleted_tasks(@user).where(["DATE(created_at)<?",d_today])
    #   # @incomplete_tasks = @tasks.where(["completed_at IS ? and DATE(created_at)=?",nil,d_today])
    #   @complete_tasks = @list.completed_tasks(@user).where('DATE(completed_at) BETWEEN ? AND ?' , d_yesterday , d_today ).order('completed_at')
    # end


    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:name, :description, :avatar, :date)
    end
end
