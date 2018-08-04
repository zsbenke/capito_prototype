require 'test_helper'

class BudgetTest < ActiveSupport::TestCase
  test "should validate" do
    budget = Budget.new

    refute budget.valid?
    assert budget.errors.messages[:current_month].present?

    budget.current_month = "String"
    refute budget.valid?
    assert budget.errors.messages[:current_month].present?
    assert_equal ["can't be blank", "is not valid Date"], budget.errors.messages[:current_month]

    budget.current_month = Date.current
    assert budget.valid?
  end

  test "should assign a date for current_month with the first day of current_month" do
    budget = Budget.new current_month: "2018-01-15".to_date
    assert_equal "2018-01-01",  budget.current_month.strftime("%Y-%m-%d")
  end

  test "should return expense budget_balance objects for current_month" do
    budget = Budget.new(current_month: "2018-01-15".to_date)
    groceries_january = budget_balances(:groceries_january)
    utilities_january = budget_balances(:utilities_january)

    assert_includes budget.expense_budget_balances, groceries_january
    assert_includes budget.expense_budget_balances, utilities_january
    refute_includes budget.expense_budget_balances, categories(:income)
    assert_equal Category.count - 1, budget.expense_budget_balances.count
    assert_equal [budget.current_month], budget.expense_budget_balances.map(&:month).uniq
  end
end
