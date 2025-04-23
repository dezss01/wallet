class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?
  include ActionController::MimeResponds
  respond_to :json

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name email password])
  end

  def formatted_devise_errors(resource)
    errors = resource.errors.to_hash.transform_values do |messages|
      messages.map(&:to_s)
    end
    render json: errors, status: :unprocessable_entity
  end
end
