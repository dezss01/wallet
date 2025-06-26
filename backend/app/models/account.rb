# == Schema Information
#
# Table name: accounts
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  balance     :decimal(20, 2)
#  currency    :string
#  description :text
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_accounts_on_user_id  (user_id)
#

class Account < ApplicationRecord
  CURRENCIES = %w[USD EUR RUB].freeze
  NAME_LENGTH_RANGE = 2..100
  DESCRIPTION_LENGTH_RANGE = 2..100

  belongs_to :user
  has_many :account_transactions, dependent: :destroy

  validates :name, presence: true, length: { within: NAME_LENGTH_RANGE }
  validates :currency, presence: true, inclusion: { in: CURRENCIES }
  validates :description, presence: true, length: { within: DESCRIPTION_LENGTH_RANGE }
  validates :user, presence: true

  def balance=(value)
    raise BalanceUpdateError, "Use Account.update_balance! method to modify balance"
  end

  def self.update_balance!(account, amount, transaction_type)
    account.with_lock do
      case transaction_type.to_sym
      when :deposit then account.send(:increment_balance!, amount)
      when :withdrawal then account.send(:decrement_balance!, amount)
      else raise ArgumentError, "Invalid transaction type: #{transaction_type}"
      end
    end
  rescue ActiveRecord::StaleObjectError
    account.reload
    retry
  end

  private

  def increment_balance!(amount)
    validate_amount(amount)
    update_columns(balance: balance + amount)
  end

  def decrement_balance!(amount)
    validate_amount(amount)
    new_balance = balance - amount
    validate_balance(new_balance)
    update_columns(balance: new_balance)
  end

  def validate_amount(amount)
    return if amount.is_a?(Numeric) && amount.positive?

    raise BalanceUpdateError, "Amount must be positive"
  end

  def validate_balance(value)
    return if value >= 0

    raise BalanceUpdateError, "Insufficient funds"
  end

  class BalanceUpdateError < StandardError; end
end
