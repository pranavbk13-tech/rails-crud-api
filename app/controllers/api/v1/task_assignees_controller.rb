class Api::V1::TaskAssigneesController < ApplicationController
  # POST /api/v1/task_assignees
  # Expects params: { task_assignee: { task_id: 1, user_id: 2 } }
  def create
    assignment = TaskAssignee.new(assignee_params)

    if assignment.save
      render_success(assignment, :created, "User successfully assigned to the task")
    else
      render_error(assignment.errors.full_messages, :unprocessable_entity)
    end
  end

  # DELETE /api/v1/task_assignees/:id
  def destroy
    assignment = TaskAssignee.find_by(id: params[:id])

    # Fallback to finding by task_id and user_id if primary key ID is not passed
    if assignment.nil? && params[:task_id].present? && params[:user_id].present?
      assignment = TaskAssignee.find_by(task_id: params[:task_id], user_id: params[:user_id])
    end

    return render_error([ "Assignment not found" ], :not_found) unless assignment

    assignment.destroy
    render_success(nil, :ok, "User successfully unassigned from the task")
  end

  private

  def assignee_params
    params.require(:task_assignee).permit(:task_id, :user_id)
  end
end
