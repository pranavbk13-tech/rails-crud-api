
class Api::V1::TasksController < ApplicationController
  before_action :set_task, only: [ :show, :update, :destroy ]

  # GET /api/v1/tasks
  def index
    tasks = Task.order(created_at: :desc)
    render_success(tasks)
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
    render_error([ "Task not found" ], :not_found) unless @task
  end

  def task_params
    params.fetch(:task, params).permit(:title, :description, :completed)
  end
end
