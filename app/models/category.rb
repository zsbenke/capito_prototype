class Category < ApplicationRecord
  include Balancable

  INCOME_CATEGORIES = ['Income'].freeze

  has_many :transactions
  has_many :budget_balances
  validates :name, presence: true

  def income?
    INCOME_CATEGORIES.include? name
  end
end
