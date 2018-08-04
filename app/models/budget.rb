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

  def budget_balances
    collected = []
    Category.all.each do |category|
      next if category.income?
      collected << BudgetBalance.find_or_initialize_by(category: category, month: current_month)
    end

    collected
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
