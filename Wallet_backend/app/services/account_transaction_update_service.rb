class AccountTransactionUpdateService
  def self.update(transaction:, params:)
    ActiveRecord::Base.transaction do
      account = transaction.account
      account.lock!

      old_amount = transaction.amount
      old_type = transaction.transaction_type.to_sym

      transaction.assign_attributes(params)
      transaction.validate!

      revert_old_transaction(account, old_amount, old_type)
      apply_new_transaction(account, transaction)

      transaction.save!
      account.save!

      transaction
    end
  end

  private_class_method def self.revert_old_transaction(account, amount, type)
    reverse_type = type == :deposit ? :withdrawal : :deposit
    Account.update_balance!(account, amount, reverse_type)
  end

  private_class_method def self.apply_new_transaction(account, transaction)
    Account.update_balance!(
      account,
      transaction.amount,
      transaction.transaction_type.to_sym
    )
  end
end
