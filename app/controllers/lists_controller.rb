class ListsController < ApplicationController
  include ApplicationHelper
  before_action :set_list, only: [:index, :show, :edit, :update, :destroy]
  before_action :require_logged_in
  before_action :set_task_per_list, only: [:index, :show ]

  def index

    @all_tasks   = current_user.tasks.where(:completed_at => nil)

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
    respond_to do |format|
      format.html{ redirect_to @list }
      format.js
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
        byebug
        @lists = current_user.created_lists.all
        set_task_per_list
        format.html{ render :index }
        format.js

      end
    end
  end

  def update

    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
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
      format.html { redirect_to root_url, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
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

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:name, :description)
    end

    def set_task_per_list

     set_date
     d_today = get_date
     d_yesterday = d_today - 1.day
    #  @tasks = @list.tasks.where('DATE(created_at) BETWEEN ? AND ?', d_yesterday , d_today )
     @tasks = @list.tasks
     @incomplete_tasks = @tasks.where(["completed_at IS ? and DATE(created_at)=?",nil,d_today])
     @complete_tasks = @tasks.where('DATE(completed_at) BETWEEN ? AND ?', d_yesterday , d_today ).order('completed_at')

     byebug
    end

end
