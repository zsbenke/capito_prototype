class BudgetBalance < ApplicationRecord
  belongs_to :category

  validates :month, presence: true

  before_save :adjust_month

  delegate :income?, to: :category

  def balance
    end_of_month = month.end_of_month
    budgeted_sum = self.class.where("month < ?", end_of_month).sum(:budgeted)
    category_balance = category.balance(until_date: end_of_month)

    if category_balance < 0
      budgeted_sum - category_balance.abs
    else
      budgeted_sum - category_balance
    end
  end

  def overspent?
    balance < 0
  end

  private

  def adjust_month
    if month.respond_to? :beginning_of_month
      self.month = month.beginning_of_month
    end
  end
end
