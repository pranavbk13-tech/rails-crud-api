
class Api::V1::TasksController < ApplicationController
  before_action :set_task, only: [ :show, :update, :destroy ]

  # GET /api/v1/tasks
  # GET /api/v1/tasks?page=2&items=3
  def index
    # tasks = Task.order(created_at: :desc)
    # render_success(tasks)
    # tasks = Task.select(:id, :title, :description, :completed, :created_at, :updated_at).order(created_at: :desc)

    tasks = Task.select(:id, :title, :created_at, :updated_at).order(created_at: :desc)

    if params[:page].present? || params[:items].present?
      @pagy, paginated_tasks = pagy(tasks, max_limit: 100, limit_key: "items")

      res_tasks = paginated_tasks
      res_pagination = @pagy.data_hash
    else
      res_tasks = tasks
      res_pagination = nil
    end
    render_success({
      tasks: res_tasks,
      pagination: res_pagination
    })
  end

  # GET /api/v1/tasks/:id
  def show
    render_success(@task)
  end

  # POST /api/v1/tasks
  def create
    task = Task.new(task_params)
    if task.save
      render_success(task, :created, "Task created successfully")
    else
      render_error(task.errors.full_messages, :unprocessable_entity)
    end
  end

  # PATCH/PUT /api/v1/tasks/:id
  def update
    if @task.update(task_params)
      render_success(@task, :ok, "Task updated successfully")
    else
      render_error(@task.errors.full_messages, :unprocessable_entity)
    end
  end

  # DELETE /api/v1/tasks/:id
  def destroy
    @task.destroy
    render_success(nil, :ok, "Task deleted successfully")
  end

  private

  def set_task
    @task = Task.find_by(id: params[:id])
    render_error([ "Task not found" ], :not_found) and return unless @task
  end

  def task_params
    params.fetch(:task, params).permit(:title, :description, :completed)
  end
end
