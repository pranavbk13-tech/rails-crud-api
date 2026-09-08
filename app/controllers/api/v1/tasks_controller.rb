module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [ :show, :update, :destroy ]

      # GET /api/v1/tasks
      def index
        tasks = Task.order(created_at: :desc)
        render json: tasks
      end

      # GET /api/v1/tasks/:id
      def show
        render json: @task
      end

      # POST /api/v1/tasks
      def create
        task = Task.new(task_params)
        if task.save
          render json: task, status: :created
        else
          render json: task.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/tasks/:id
      def update
        if @task.update(task_params)
          render json: @task
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/tasks/:id
      def destroy
        @task.destroy
        head :no_content
      end

      private

      def set_task
        @task = Task.find(request.path_parameters[:id])
      end

      def task_params
        raw_body = request.body.read
        return ActionController::Parameters.new if raw_body.empty?

        parsed = JSON.parse(raw_body)
        payload = parsed.is_a?(Hash) ? (parsed["task"] || parsed) : {}
        ActionController::Parameters.new(payload).permit(:title, :description, :completed)
      rescue JSON::ParserError
        ActionController::Parameters.new
      end
    end
  end
end
