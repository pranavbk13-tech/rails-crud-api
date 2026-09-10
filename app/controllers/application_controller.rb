class ApplicationController < ActionController::API
  include ApiResponse
  include Pagy::Method
end
