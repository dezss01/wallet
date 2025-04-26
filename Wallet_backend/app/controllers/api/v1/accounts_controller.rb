# app/controllers/api/v1/accounts_controller.rb
module Api
  module V1
    class AccountsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_account, only: [ :show, :update, :destroy ]

      def index
        @accounts = current_user.accounts
        render json: @accounts
      end

      def show
        render json: @account
      end

      def create
        @account = current_user.accounts.new(account_params.except(:balance))

        ActiveRecord::Base.transaction do
          @account.save!
          @account.update_columns(balance: account_params[:balance].to_f) # Инициализируем баланс нулем
          render json: @account, status: :created
        end
      rescue ActiveRecord::RecordInvalid => e
        render json: ErrorSerializer.serialize(e.record.errors), status: :unprocessable_entity
      rescue => e
        render json: ErrorSerializer.serialize(e.message), status: :unprocessable_entity
      end

      def update
        @account.update!(account_params.except(:balance))

        ActiveRecord::Base.transaction do
          @account.update_columns(balance: account_params[:balance].to_f) # Инициализируем баланс нулем
          render json: @account, status: :created
        end
      rescue ActiveRecord::RecordInvalid => e
        render json: ErrorSerializer.serialize(e.record.errors), status: :unprocessable_entity
      rescue => e
        render json: ErrorSerializer.serialize(e.message), status: :unprocessable_entity
      end

      def destroy
        @account.delete
        head :no_content
      end

      private

      def set_account
        @account = current_user.accounts.find_by(id: params[:id])
      rescue ActiveRecord::RecordNotFound
        render_error("Залогинься кретинушка!", :not_found)
      end

      def account_params
        params.expect(account: [ :id, :name, :balance, :description, :currency ])
      end
    end
  end
end
