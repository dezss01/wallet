class AddCascadeDeleteToAccountTransactions < ActiveRecord::Migration[8.0]
  def up
    # Удаляем существующий foreign key
    remove_foreign_key :account_transactions, :accounts

    # Добавляем новый foreign key с каскадным удалением
    add_foreign_key :account_transactions, :accounts,
                    on_delete: :cascade
  end

  def down
    remove_foreign_key :account_transactions, :accounts
    add_foreign_key :account_transactions, :accounts
  end
end
