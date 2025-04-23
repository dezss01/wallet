class Account < ApplicationRecord
  belongs_to :user

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
end
