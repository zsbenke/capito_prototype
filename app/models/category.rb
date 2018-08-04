class Category < ApplicationRecord
  include Balancable

  has_many :transactions
  has_many :budget_balances
  validates :name, presence: true

  def income?
    name == "Income"
  end
end
