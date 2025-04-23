# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [ :create ]
    before_action :authenticate_user!
    # skip_before_action :verify_authenticity_token
    before_action :configure_account_update_params, only: [ :update ]
    respond_to :json
    # GET /resource/sign_up
    # def new
    #   super
    # end

    # POST /resource
    def create
      super do |resource|
        formatted_devise_errors(resource) and return if resource.errors.any?
      end
    end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    def update
      super do |resource|
        if resource.errors.any?
          formatted_devise_errors(resource) and return
        else
          render json: { message: "update successfully", user: @user } and return
        end
      end
    end

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
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name user_name email password])
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update,
                                        keys: %i[first_name last_name user_name email password password_confirmation
                                                 current_password])
    end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end

    private

    def account_update_params
      params.expect(user: [ :first_name, :last_name, :user_name, :email, :password, :password_confirmation,
      :current_password ])
    end

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
      params.expect(registration: [ :first_name, :last_name, :user_name, :email, :password ])
    end
  end
end
