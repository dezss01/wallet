module Api
  module V1
    class AccountTransactionsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_account, only: %i[index create]
      before_action :set_account_transaction, only: %i[show update destroy]

      def index
        @transactions = @account.account_transactions
        render json: @transactions, each_serializer: AccountTransactionSerializer
      end

      def show
      end

      def create
        @account_transaction = @account.account_transactions.new(account_transaction_params)

        if @account_transaction.save
          render json: @account_transaction, serializer: AccountTransactionSerializer, status: :created
        else
          render json: ErrorSerializer.serialize(@account_transaction.errors), status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: ErrorSerializer.serialize(e.message), status: :internal_server_error
      end

      def update
        if @account_transaction.update(account_transaction_params)
          render json: @account_transaction, serializer: AccountTransactionSerializer
        else
          render json: { errors: @account_transaction.errors, received_params: params.to_unsafe_h }, status: :unprocessable_entity
        end
      end

      def destroy
        @account_transaction.destroy
        head :no_content
      end


      private

      def set_account
        @account = current_user.accounts.find(params[:account_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Account not found" }, status: :not_found
      end

      def set_account_transaction
        @account_transaction = AccountTransaction.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Account transaction not found" }, status: :not_found
      end

      def account_transaction_params
        params.expect(account_transaction: [ :id, :amount, :transaction_type, :currency, :description, :account_id ])
      end
    end
  end
end
