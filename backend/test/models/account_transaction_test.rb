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

require "test_helper"

class AccountTransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
