class ListsController < ApplicationController
  before_action :set_list, only: [:index, :show, :edit, :update, :destroy]
  before_action :require_logged_in
  # GET /todo_lists
  # GET /todo_lists.json
  def index
    @lists = current_user.created_lists.all
    @collaboration_lists = current_user.collaboration_lists.all
    if (params[:id] == nil)
      @list = @lists.first
    end
      set_task_per_list
      # @tasks = @lists.first
      # @incomplete_tasks = @tasks.where(:completed_at => nil)
      # @complete_tasks = @tasks.where.not(:completed_at => nil)


    @all_tasks   = current_user.tasks.where(:completed_at => nil)
    # @task   = current_user.tasks.new
    # @task   = current_user.tasks.new
    # @list   = current_user.created_lists.new

    # respond_to do |format|
    #   format.html
    #   format.json do
    #     render :json => {:tasks => Task.all.map(&:to_json) }
    #   end
    # end
  end

  # GET /todo_lists/1
  # GET /todo_lists/1.json
  def show
    @list = List.find(params[:id])
    set_task_per_list
    respond_to do |format|
      format.html{ redirect_to @lists }
      format.js
   end
  end

  # GET /todo_lists/new
  def new
    @list = current_user.created_lists.new
  end

  # GET /todo_lists/1/edit
  def edit
  end

  # POST /todo_lists
  # POST /todo_lists.json
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

  # PATCH/PUT /todo_lists/1
  # PATCH/PUT /todo_lists/1.json
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

  # DELETE /todo_lists/1
  # DELETE /todo_lists/1.json
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
      if (params[:id]!=nil)
        @list = List.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:name, :description)
    end

    def set_task_per_list
      @tasks = @list.tasks
      @incomplete_tasks = @tasks.where(:completed_at => nil)
      @complete_tasks = @tasks.where.not(:completed_at => nil)
    end
end
