class AccountSerializer < ActiveModel::Serializer
  attributes :id, :name, :balance, :currency, :description, :user_id
  # belongs_to :user
end
