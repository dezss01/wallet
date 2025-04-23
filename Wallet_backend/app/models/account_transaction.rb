# == Schema Information
#
# Table name: account_transactions
#
#  id               :integer          not null, primary key
#  amount           :decimal(15, 2)
#  transaction_type :string
#  currency         :string
#  description      :string
#  account_id       :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_account_transactions_on_account_id  (account_id)
#

class AccountTransaction < ApplicationRecord
  belongs_to :account

  CURRENCIES = %w[USD EUR RUB].freeze
  TRANSACTION_TYPES = %w[deposit withdrawal].freeze
  MAX_BALANCE = 100_000_000_000_000_000.00
  MIN_BALANCE = -100_000_000_000_000_000.00
  NAME_LENGTH_RANGE = 3..100
  DESCRIPTION_LENGTH_RANGE = 3..100

  validates :amount, presence: true,
                      numericality: {
                        decimal: true,
                        less_than: MAX_BALANCE,
                        greater_than: MIN_BALANCE
                      }

  validates :transaction_type, presence: true, inclusion: { in: TRANSACTION_TYPES }
  validates :currency, presence: true, inclusion: { in: CURRENCIES }
  validates :description, presence: true, length: { within: DESCRIPTION_LENGTH_RANGE }

  after_create :update_account_balance

  private

  def update_account_balance
    case transaction_type
    when "deposit"
      account.update!(balance: account.balance + amount)
    when "withdrawal"
      account.update!(balance: account.balance - amount)
    end
  end
end
