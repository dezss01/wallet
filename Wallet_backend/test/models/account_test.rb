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

require "test_helper"

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
