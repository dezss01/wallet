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
  has_many :account_transactions, dependent: :destroy

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

  def update_balance!(amount, transaction_type)
    case transaction_type
    when "deposit" then increment!(:balance, amount)
    when "withdrawal" then decrement!(:balance, amount)
    end
  rescue ActiveRecord::StaleObjectError
    reload
    retry
  end


  private

  def increment!(field, value)
    update!(field => self[field] + value)
  end

  def decrement!(field, value)
    update!(field => self[field] - value)
  end
end
