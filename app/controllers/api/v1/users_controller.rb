class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :destroy ]

  # GET /api/v1/users
  def index
    users = User.all
    render_success({
      users: users
    })
  end

  # GET /api/v1/users/:id
  def show
    render_success(@user)
  end

  # POST /api/v1/users
  def create
    user = User.new(user_params)
    if user.save
      render_success(user, :created, "User created successfully")
    else
      render_error(user.errors.full_messages, :unprocessable_entity)
    end
  end

  def update
    if @user.update(user_params)
      render_success(@user, :ok, "User updated successfully")
    else
      render_error(@user.errors.full_messages, :unprocessable_entity)
    end
  end

  # DELETE /api/v1/users/:id
  def destroy
    @user.destroy
    render_success(nil, :ok, "User deleted successfully")
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render_error([ "User not found" ], :not_found) and return unless @user
  end

  def user_params
    params.fetch(:user, params).permit(:username, :email)
  end
end
