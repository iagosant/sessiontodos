module TasksHelper

def add_deadline
  byebug
  @task.update_attribute(:deadline, params[:datepicker])
  byebug
  respond_to do |format|
    format.html {  redirect_to @list, notice: "Task completed" }
    format.js
  end
end

end
