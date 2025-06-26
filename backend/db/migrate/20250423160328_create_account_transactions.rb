class CreateAccountTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :account_transactions do |t|
      t.decimal :amount, precision: 15, scale: 2
      t.string :transaction_type
      t.string :currency
      t.string :description
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
