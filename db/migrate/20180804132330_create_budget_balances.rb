class CreateBudgetBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :budget_balances do |t|
      t.references :category, foreign_key: true
      t.float :budgeted, default: 0.0
      t.date :month

      t.timestamps
    end
  end
end
