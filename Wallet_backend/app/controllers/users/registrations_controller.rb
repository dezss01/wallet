# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    # before_action :configure_sign_up_params, only: %i[ create ]
    # before_action :configure_account_update_params, only: %i[ update ]
    respond_to :json
    #
    # def new
    #   super do |resource|
    #     puts("____________________________ХУИТА_______________________")
    #     # formatted_devise_errors(resource) and return if resource.errors.any?
    #   end
    # end

    def create
      puts("____________________________ХУИТА2_______________________")
      build_resource(sign_up_params)

      if resource.save
        render json: { message: "User registered successfully" }, status: :created
      else
        render json: { message: "User registration failed" }, status: :unprocessable_entity
      end
    end

    # def update
    #   if update_resource(resource, account_update_params)
    #     render json: {
    #       status: "success",
    #       message: "Profile updated successfully",
    #       user: serialized_user_data(resource)
    #     }, status: :ok
    #   else
    #     render json: {
    #       status: "error",
    #       message: "Profile update failed",
    #       errors: formatted_errors(resource)
    #     }, status: :unprocessable_entity
    #   end
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:registration, keys: %i[first_name last_name user_name email password])
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update,
    #                                     keys: %i[first_name last_name user_name email password password_confirmation
    #                                              current_password])
    # end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end

    private

    # def respond_with(resource, _opts = {})
    #   if resource.persisted?
    #     render json: {
    #       message: "Signed up successfully.",
    #       user: resource
    #     }, status: :ok
    #   else
    #     render json: {
    #       error: resource.errors.full_messages
    #     }, status: :unprocessable_entity
    #   end
    # end

    def serialized_user_data(user)
      user.as_json(
        only: [
          :id,
          :first_name,
          :last_name,
          :user_name,
          :email
        ]
      )
    end

    def formatted_errors(resource)
      resource.errors.attribute_errors.transform_values do |messages|
        messages.map(&:to_s)
    end

    # def account_update_params
    #   params.expect(user: %i[ first_name last_name user_name email password password_confirmation current_password ])
    # end

    def respond_with(resource, _opts = {})
      register_success && return if resource.persisted?

      register_failed
    end

    def register_success
      render json: { message: "Signed up successfully111.", user: @user }
    end

    def register_failed
      render json: { message: resource.errors }, status: :unprocessable_entity
    end

    def sign_up_params
      params.expect(registration: %i[ first_name last_name user_name email password ])
    end
    end
  end
end
