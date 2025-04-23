# app/controllers/api/v1/accounts_controller.rb
module Api
  module V1
    class AccountsController < ApplicationController
      before_action :set_account, only: [ :show, :update, :destroy ]

      def index
        @accounts = current_user.accounts
        render json: @accounts
      end

      def show
        render json: @account
      end

      def create
        @account = current_user.accounts.build(account_params)

        if @account.save
          render json: @account, status: :created
        else
          render json: ErrorSerializer.serialize(@account.errors), status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: ErrorSerializer.serialize(e.message), status: :internal_server_error
      end

      def update
        if @account.update(account_params)
          render json: @account
        else
          render json: { errors: @account.errors, received_params: params.to_unsafe_h }, status: :unprocessable_entity

        end
      end

      def destroy
        @account.delete
        head :no_content
      end

      private

      def set_account
        @account = current_user.accounts.find_by(id: params[:id])
        # rescue ActiveRecord::RecordNotFound
        #   render_error("Account not found", :not_found)
      end

      def account_params
        params.expect(account: [ :id, :name, :balance, :description, :currency ])
      end
    end
  end
end
