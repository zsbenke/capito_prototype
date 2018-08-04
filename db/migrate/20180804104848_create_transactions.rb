class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :category, foreign_key: true
      t.references :account, foreign_key: true
      t.float :amount
      t.string :payee
      t.text :note

      t.timestamps
    end
  end
end
