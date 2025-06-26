class AccountTransactionDestroyService
  def self.destroy(transaction)
    ActiveRecord::Base.transaction do
      account = transaction.account
      account.lock!

      reverse_type = transaction.transaction_type.to_sym == :deposit ? :withdrawal : :deposit
      Account.update_balance!(account, transaction.amount, reverse_type)

      transaction.destroy!
      account.save!
    end
  end
end
