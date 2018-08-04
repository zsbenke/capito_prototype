class BudgetBalance < ApplicationRecord
  belongs_to :category

  validates :month, presence: true

  before_save :adjust_month

  delegate :income?, to: :category

  def balance
    end_of_month = month.end_of_month
    category_balance = category.balance(until_date: end_of_month)
    return category_balance if income?

    expenses_balance = if category_balance < 0
      budgeted_balance - category_balance.abs
    else
      budgeted_balance - category_balance
    end
    return expenses_balance
  end

  def budgeted_balance
    end_of_month = month.end_of_month
    budgeted_sum = self.class.where(category: category)
      .where("month < ?", end_of_month).sum(:budgeted)
    budgeted_sum
  end

  def spent_balance
    beginning_of_month = month.beginning_of_month
    end_of_month = month.end_of_month
    category_balance = category.balance(start_date: beginning_of_month, until_date: end_of_month)
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
