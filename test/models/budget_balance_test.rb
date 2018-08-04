require 'test_helper'

class BudgetBalanceTest < ActiveSupport::TestCase
  test "should validate" do
    budget_balance = BudgetBalance.new

    refute budget_balance.valid?
    assert budget_balance.errors.messages[:category].present?
    assert budget_balance.errors.messages[:month].present?
  end

  test "should save date for month with the first day of month" do
    budget_balance = BudgetBalance.new(
      category: categories(:groceries),
      month: '2018-01-15'
    )
    budget_balance.save
    assert_equal "2018-01-01", budget_balance.reload.month.strftime("%Y-%m-%d")
  end

  test "should return balance for the current month" do
    travel_to "2018-01-15".to_time

    groceries_january = budget_balances :groceries_january
    account = accounts :otp_smart
    category = groceries_january.category

    groceries_january.update(budgeted: 10000)
    Transaction.create account: account, category: category, amount: -1000
    Transaction.create account: account, category: category, amount: -500
    Transaction.create account: account, category: category, amount: -2000

    assert_equal -3500.0, category.balance
    assert_equal 6500.0, groceries_january.balance

    travel_to "2018-02-15"

    groceries_february = budget_balances :groceries_february

    groceries_february.update(budgeted: 5000)
    Transaction.create account: account, category: category, amount: -1000
    Transaction.create account: account, category: category, amount: -1000

    assert_equal -5500, category.balance
    assert_equal 9500, groceries_february.balance

    Transaction.create account: account, category: category, amount: 1000
    assert_equal -4500, category.balance
    assert_equal 10500, groceries_february.balance

    Transaction.create account: account, category: category, amount: -11000
    assert_equal -15500, category.balance
    assert_equal -500, groceries_february.balance
  end

  test "should check if budget_balance is overspent" do
    travel_to "2018-02-15"

    account = accounts :otp_smart
    groceries_february = budget_balances :groceries_february

    groceries_february.update(budgeted: 2000)
    Transaction.create account: account, category: groceries_february.category, amount: -3000
    assert groceries_february.overspent?

    groceries_february.update(budgeted: 4000)
    refute groceries_february.overspent?
  end

  test "should return income status of budget_balance" do
    income_january = BudgetBalance.new(category: categories(:income), month: '2018-01-01'.to_date)
    assert income_january.income?
    groceries_february = budget_balances :groceries_february
    refute groceries_february.income?
  end
end
