module Api
  module V1
    class AccountTransactionsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_account, only: [ :index, :new, :create ]
      before_action :set_transaction, only: [ :show, :update, :destroy ]

      def index
        @transactions = @account.account_transactions
        render json: @transactions
      end

      def show
        render json: @transaction
      end


      def new; end

      def create
        transaction = AccountTransactionService.create(transaction_params)
        render json: transaction, status: :created
      rescue => e
        handle_error(e)
      end

      def update
        transaction = AccountTransactionUpdateService.update(
          transaction: @transaction,
          params: transaction_params
        )
        render json: transaction
      rescue => e
        handle_error(e)
      end

      def destroy
        AccountTransactionDestroyService.destroy(@transaction)
        head :no_content
      rescue => e
        handle_error(e)
      end

      private

      def transaction_params
        params.require(:account_transaction).permit(
          :amount,
          :transaction_type,
          :currency,
          :description,
          :account_id
        )
      end

      def set_account
        @account = current_user.accounts.find(params[:account_id])
      end

      def set_transaction
        @transaction = current_user.account_transactions.find(params[:id])
      end

      def handle_error(error)
        case error
        when ActiveRecord::RecordNotFound
          render json: { error: "Not found" }, status: :not_found
        when Account::BalanceUpdateError,
             AccountTransaction::ValidationError,
             ArgumentError
          render json: { error: error.message }, status: :unprocessable_entity
        else
          render json: { error: "Internal error" }, status: :internal_server_error
        end
      end
    end
  end
end
