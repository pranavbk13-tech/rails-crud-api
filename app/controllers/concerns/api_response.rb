module ApiResponse
  extend ActiveSupport::Concern

  private

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
