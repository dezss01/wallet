class AccountTransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :transaction_type, :currency, :description, :account_id, :created_at, :updated_at

  # belongs_to :account, serializer: AccountSerializer

  def created_at
    object.created_at.iso8601
  end

  def updated_at
    object.updated_at.iso8601
  end

  # Преобразование суммы к float
  def amount
    object.amount.to_f
  end
end
