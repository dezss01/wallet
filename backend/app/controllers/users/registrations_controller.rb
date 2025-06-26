# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [ :create ]
  respond_to :json

  def create
    build_resource(sign_up_params)

    if resource.save
      render json: {
        message: "User registered successfully",
        user: resource.as_json(only: [ :id, :email, :first_name, :last_name, :user_name ])
      }, status: :created
    else
      render json: {
        message: "User registration failed",
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :user_name, :email, :password ])
  end

  private

  def sign_up_params
    params.require(:registration).permit(:first_name, :last_name, :user_name, :email, :password)
  end
end
