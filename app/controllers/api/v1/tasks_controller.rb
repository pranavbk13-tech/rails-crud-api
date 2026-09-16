
class Api::V1::TasksController < ApplicationController
  before_action :set_task, only: [ :show, :update, :destroy ]


  # ##page = 1
  #
  # per 50
  #

  # GET /api/v1/tasks
  # GET /api/v1/tasks?page=1&items=4
  def index
    # tasks = Task.select(:id, :title, :description, :completed, :created_at, :updated_at).order(created_at: :desc)

    tasks = Task.includes(:users).select(:id, :title, :created_at, :updated_at).order(created_at: :desc)

    @pagy, paginated_tasks = pagy(tasks, max_limit: 100, limit_key: "items")

    render_success({
      tasks: paginated_tasks.as_json(include: :users),
      pagination: @pagy.data_hash
    })
  end

  # GET /api/v1/tasks/pagy_get
  # GET /api/v1/tasks/pagy_get?title=foo&page=1&items=4
  def pagy_get
    title = params[:title].to_s.strip
    tasks = Task.select(:id, :title, :created_at, :updated_at).order(created_at: :desc)
    tasks = tasks.where("title ILIKE ?", "%#{title}%") if title.present?

    @pagy, paginated_tasks = pagy(tasks, max_limit: 100, limit_key: "items")

    render_success({
      tasks: paginated_tasks,
      pagination: @pagy.data_hash
    })
  end

  # GET /api/v1/tasks/kaminari_get?page=1&items=4
  def kaminari_get
    title = params[:title].to_s.strip
    tasks = Task.select(:id, :title, :created_at, :updated_at).order(created_at: :desc)
    tasks = tasks.where("title ILIKE ?", "%#{title}%") if title.present?

    @tasks = tasks.page(params[:page]).per(params[:items])

    render_success({
      tasks: @tasks,
      pagination: {
        current_page: @tasks.current_page,
        next_page: @tasks.next_page,
        prev_page: @tasks.prev_page,
        total_pages: @tasks.total_pages,
        total_count: @tasks.total_count,
        items_per_page: @tasks.limit_value
      }
    })
  end


  # POST /api/v1/tasks/kaminari_post
  def kaminari_post
    title = params[:title].to_s.strip
    tasks = Task.select(:id, :title, :created_at, :updated_at).order(created_at: :desc)
    tasks = tasks.where("title ILIKE ?", "%#{title}%") if title.present?

    @tasks = tasks.page(params[:page]).per(params[:items])

    render_success({
      tasks: @tasks,
      pagination: {
        current_page: @tasks.current_page,
        next_page: @tasks.next_page,
        prev_page: @tasks.prev_page,
        total_pages: @tasks.total_pages,
        total_count: @tasks.total_count,
        items_per_page: @tasks.limit_value
      }
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
