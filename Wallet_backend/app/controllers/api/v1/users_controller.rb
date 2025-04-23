# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def update
      if password_change_requested?
        update_with_password
      else
        update_without_password
      end
    end

    private

    def update_with_password
      if current_user.valid_password?(user_params[:current_password])
        if current_user.update_with_password(user_params)
          current_user.reload
          render json: { message: "Profile updated successfully.", user: user_data }
        else
          render json: { error: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Current password is incorrect" }, status: :unprocessable_entity
      end
    end

    def update_without_password
      if current_user.update(user_params.except(:current_password, :password, :password_confirmation))
        current_user.reload
        render json: { message: "Profile updated successfully.", user: user_data }
      else
        render json: { error: current_user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def password_change_requested?
      user_params[:password].present? || user_params[:password_confirmation].present?
    end

    def user_params
      params.expect(user: [ :first_name, :last_name, :user_name, :email, :current_password, :password,
                                   :password_confirmation ])
    end

    def user_data
      current_user.as_json(only: %i[id first_name last_name user_name email created_at updated_at])
    end
  end
end
