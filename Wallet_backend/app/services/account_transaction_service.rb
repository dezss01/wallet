# app/services/account_transaction_service.rb
class AccountTransactionService
  def self.create(params)
    new(params).execute
  end

  def initialize(params)
    @account = Account.find(params[:account_id])
    @params = params.except(:account_id)
  end

  def execute
    ActiveRecord::Base.transaction do
      @account.lock!
      transaction = build_transaction
      update_balance(transaction)
      save_transaction(transaction)
    end
  end

  private

  def build_transaction
    AccountTransaction.new(
      account: @account,
      amount: @params[:amount],
      transaction_type: @params[:transaction_type],
      currency: @params[:currency],
      description: @params[:description]
    ).tap(&:validate!)
  end

  def update_balance(transaction)
    Account.update_balance!(
      @account,
      transaction.amount,
      transaction.transaction_type.to_sym
    )
  end

  def save_transaction(transaction)
    transaction.save!
    @account.save!
    transaction
  end
end
