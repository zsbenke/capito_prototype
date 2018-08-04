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

  test "should return income budget_balance objects for current_month" do
    budget = Budget.new(current_month: "2018-01-15".to_date)
    assert_equal 1, budget.income_budget_balances.count
    assert_equal [budget.current_month], budget.income_budget_balances.map(&:month).uniq
    assert_equal Category::INCOME_CATEGORIES, budget.income_budget_balances
      .map { |b| b.category.name }.uniq
  end

  test "should update balances" do
    account = accounts :otp_smart
    budget = Budget.new(current_month: "2018-01-15".to_date)
    income = categories :income
    groceries = categories :groceries
    apps = categories :apps

    travel_to "2018-01-15".to_date

    Transaction.create(category: income, account: account, amount: 100000)
    assert_equal 100000.0, budget.available_for_budget
    assert_equal 0.0, budget.find_budget_balance(groceries).balance
    assert_equal 0.0, budget.find_budget_balance(apps).balance

    budget.add(10000, to: groceries)
    assert_equal 90000.0, budget.available_for_budget
    assert_equal 10000.0, budget.find_budget_balance(groceries).balance
    assert_equal 0.0, budget.find_budget_balance(apps).balance

    Transaction.create(category: groceries, account: account, amount: 5000)
    assert_equal 90000.0, budget.available_for_budget
    assert_equal 5000.0, budget.find_budget_balance(groceries).balance
    assert_equal 0.0, budget.find_budget_balance(apps).balance

    budget.add(15000, to: groceries)
    assert_equal 85000.0, budget.available_for_budget
    assert_equal 10000.0, budget.find_budget_balance(groceries).balance
    assert_equal 0.0, budget.find_budget_balance(apps).balance

    budget.add(2000, to: apps)
    assert_equal 83000.0, budget.available_for_budget
    assert_equal 10000.0, budget.find_budget_balance(groceries).balance
    assert_equal 2000.0, budget.find_budget_balance(apps).balance

    Transaction.create(category: apps, account: account, amount: 1500)
    assert_equal 83000.0, budget.available_for_budget
    assert_equal 10000.0, budget.find_budget_balance(groceries).balance
    assert_equal 500.0, budget.find_budget_balance(apps).balance

    budget.current_month = "2018-02-01".to_date
    assert_equal 83000.0, budget.available_for_budget
    assert_equal 10000.0, budget.find_budget_balance(groceries).balance
    assert_equal 500.0, budget.find_budget_balance(apps).balance

    budget.add(50000, to: groceries)
    assert_equal 33000.0, budget.available_for_budget
    assert_equal 60000.0, budget.find_budget_balance(groceries).balance
    assert_equal 500.0, budget.find_budget_balance(apps).balance

    Transaction.create(category: apps, account: account, amount: 35000)
    assert_equal 33000.0, budget.available_for_budget
    assert_equal 60000.0, budget.find_budget_balance(groceries).balance
    assert_equal -34500.0, budget.find_budget_balance(apps).balance

    budget.current_month = "2018-03-01".to_date
    assert_equal 33000.0, budget.available_for_budget
    assert_equal 60000.0, budget.find_budget_balance(groceries).balance
    assert_equal -34500.0, budget.find_budget_balance(apps).balance

    budget.add(34500, to: apps)
    assert_equal -1500.0, budget.available_for_budget
    assert_equal 60000.0, budget.find_budget_balance(groceries).balance
    assert_equal 0.0, budget.find_budget_balance(apps).balance

    budget.remove(1500, from: groceries)
    assert_equal 0.0, budget.available_for_budget
    assert_equal 58500.0, budget.find_budget_balance(groceries).balance
    assert_equal 0.0, budget.find_budget_balance(apps).balance

    budget.move(10000, from: groceries, to: apps)
    assert_equal 0.0, budget.available_for_budget
    assert_equal 48500.0, budget.find_budget_balance(groceries).balance
    assert_equal 10000.0, budget.find_budget_balance(apps).balance
  end
end
