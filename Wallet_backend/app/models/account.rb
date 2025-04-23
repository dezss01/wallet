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
  belongs_to :user
  has_many :account_transactions

  CURRENCIES = %w[USD EUR RUB].freeze
  MAX_BALANCE = 100_000_000_000_000_000.00
  MIN_BALANCE = -100_000_000_000_000_000.00
  NAME_LENGTH_RANGE = 3..100
  DESCRIPTION_LENGTH_RANGE = 3..100

  validates :name, presence: true, length: { within: NAME_LENGTH_RANGE }
  validates :balance, presence: true,
                      numericality: {
                        decimal: true,
                        less_than: MAX_BALANCE,
                        greater_than: MIN_BALANCE
                      }

  validates :currency, presence: true, inclusion: { in: CURRENCIES }
  validates :description, presence: true, length: { within: DESCRIPTION_LENGTH_RANGE }
  validates :user, presence: { message: "must be present" }
  validate :balance_cannot_be_negative

  private

  def balance_cannot_be_negative
    if balance < 0
      errors.add(:balance, "cannot be negative")
    end
  end
end
