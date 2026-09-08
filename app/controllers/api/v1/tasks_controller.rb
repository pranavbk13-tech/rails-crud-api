module Api
  module V1
    class TasksController < ApplicationController
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
        nil if performed?
      end

      def task_params
        raw_body = request.body.read
        return ActionController::Parameters.new if raw_body.blank?

        parsed = JSON.parse(raw_body)
        payload = parsed.is_a?(Hash) ? (parsed["task"] || parsed) : {}
        ActionController::Parameters.new(payload).permit(:title, :description, :completed)
      rescue JSON::ParserError
        ActionController::Parameters.new
      end

      def render_success(data, status = :ok, message = nil)
        response_body = { success: true, data: data }
        response_body[:message] = message if message.present?
        render json: response_body, status: status
      end

      def render_error(errors, status = :bad_request, message = nil)
        response_body = { success: false, errors: Array(errors) }
        response_body[:message] = message if message.present?
        render json: response_body, status: status
      end
    end
  end
end
