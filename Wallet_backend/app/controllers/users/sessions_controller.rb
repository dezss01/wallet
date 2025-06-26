# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    before_action :configure_sign_in_params, only: [ :create ]
    respond_to :json

    def create
      super do |resource|
        formatted_devise_errors(resource) and return if resource.errors.any?
      end
    end

    protected

    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
    end

    private

    def respond_with(_resource, _opts = {})
      render json: {
        message: "You are logged in.",
        user: current_user
      }, status: :ok
    end

    def respond_to_on_destroy
      log_out_success && return if current_user

      logout_failure
    end

    def log_out_success
      render json: { message: "logout success" }, status: :ok
    end

    def logout_failure
      render json: { message: "Logged out failure." }, status: :unauthorized
    end
  end
end
