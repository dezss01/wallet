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

  after_create :apply_transaction
  after_update :adjust_balance
  after_destroy :reverse_transaction

  private

  def apply_transaction
    account.with_lock do
      account.update_balance!(amount, transaction_type)
    end
  end

  def adjust_balance
    return unless saved_change_to_amount? || saved_change_to_transaction_type?

    account.with_lock do
      # Отменяем предыдущее влияние
      old_amount = amount_before_last_save || 0
      old_type = transaction_type_before_last_save || transaction_type
      account.update_balance!(-old_amount, old_type)

      # Применяем новые изменения
      account.update_balance!(amount, transaction_type)
    end
  end

  def reverse_transaction
    account.with_lock do
      account.update_balance!(-amount, transaction_type)
    end
  end
end
