class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.decimal :balance, precision: 20, scale: 2
      t.string :currency
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
