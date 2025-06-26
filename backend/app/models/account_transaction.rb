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

  # Константы для валидации
  CURRENCIES = %w[USD EUR RUB].freeze
  TRANSACTION_TYPES = %w[deposit withdrawal].freeze
  DESCRIPTION_LENGTH_RANGE = 2..100

  # Валидации
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: TRANSACTION_TYPES }
  validates :currency, presence: true, inclusion: { in: CURRENCIES }
  validates :description, presence: true, length: { within: DESCRIPTION_LENGTH_RANGE }
  validate :currency_matches_account

  private

  def currency_matches_account
    nil if currency == account.currency

  rescue AccountTransaction::ValidationError => e
    errors.add(:currency, "должно соответствовать валюте счета (#{account.currency})! #{e.message}")
  end

  def apply_transaction
    Account.update_balance!(account, amount, transaction_type.to_sym)
  rescue Account::BalanceUpdateError => e
    errors.add(:base, "Не удалось применить транзакцию: #{e.message}")
    throw :abort
  end

  def adjust_balance
    return unless saved_change_to_amount? || saved_change_to_transaction_type?

    # old_amount = amount_before_last_save.to_d
    old_type = transaction_type_before_last_save

    Account.transaction do
      reverse_transaction_type = old_type == :deposit ? :withdrawal : :deposit
      Account.update_balance!(account, amount, reverse_transaction_type)

      # Account.update_balance!(account, amount, transaction_type.to_sym)
    end
  rescue Account::BalanceUpdateError => e
    restore_attributes
    errors.add(:base, "Корректировка баланса провалилась: #{e.message}")
    throw :abort
  end

  def reverse_transaction
    Account.update_balance!(account, -amount, transaction_type.to_sym)
  rescue Account::BalanceUpdateError => e
    errors.add(:base, "Отмена транзакции не выполнена: #{e.message}")
    throw :abort
  end

  class ValidationError < StandardError; end
end
