class Budget
  include ActiveModel::Model

  attr_accessor :current_month

  validates :current_month, presence: true
  validate :current_month_has_to_be_a_date

  def current_month=(value)
    if valid_date?(value)
      @current_month = value.beginning_of_month
    end
  end

  def expense_budget_balances
    collected = []
    Category.where.not(name: Category::INCOME_CATEGORIES).each do |category|
      collected << BudgetBalance.find_or_create_by(category: category, month: current_month)
    end

    collected
  end

  def income_budget_balances
    collected = []
    Category.where(name: Category::INCOME_CATEGORIES).each do |category|
      collected << BudgetBalance.find_or_create_by(category: category, month: current_month)
    end

    collected
  end

  def available_for_budget
    balance = 0

    income_budget_balances.each do |budget_balance|
      balance += budget_balance.balance
    end

    expense_budget_balances.each do |budget_balance|
      balance -= budget_balance.budgeted_balance
    end

    balance
  end

  def add(amount, to:)
    budget_balance = find_budget_balance to
    budget_balance.budgeted = amount
    budget_balance.save
  end

  def move(amount, from:, to:)
    budget_balance_from = find_budget_balance from
    budget_balance_to = find_budget_balance to
    budget_balance_from.budgeted -= amount
    budget_balance_to.budgeted += amount
    budget_balance_from.save
    budget_balance_to.save
  end

  def remove(amount, from:)
    budget_balance = find_budget_balance from
    budget_balance.budgeted -= amount
    budget_balance.save
  end

  def find_budget_balance(category)
    expense_budget_balances.find { |bb| bb.category == category }
  end

  private

  def valid_date?(value)
    value.is_a?(Date)
  end

  def current_month_has_to_be_a_date
    unless valid_date?(current_month)
      errors.add(:current_month, 'is not valid Date')
    end
  end
end
