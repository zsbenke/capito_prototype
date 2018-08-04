require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "should validate category" do
    category = Category.new

    refute category.valid?
    assert category.errors.messages[:name].present?
  end

  test "should return income category status" do
    category = categories :income
    assert category.income?

    category = categories :groceries
    refute category.income?
  end

  test "should calculate balance" do
    account = accounts :otp_smart
    category = categories :groceries
    balance_assertion = 0.0

    assert_equal balance_assertion, category.balance

    10.times do
      transaction = Transaction.create(
        account: account,
        category: category,
        amount: random_amount
      )
      assert transaction.valid?
      balance_assertion += transaction.amount
    end

    assert_equal balance_assertion, category.balance
  end

  test "should calculate balance until a date" do
    def generate_transactions(account, category)
      10.times do
        transaction = Transaction.create(
          account: account,
          category: category,
          amount: random_amount
        )
        assert transaction.valid?
        travel 1.day
      end
    end

    account = accounts :otp_smart
    category = categories :groceries

    travel_to "2018-01-01".to_time
    generate_transactions account, category
    balance_until_january = 0.0
    account.reload.transactions.pluck(:amount).map { |a| balance_until_january += a }

    travel_to "2018-02-01".to_time
    generate_transactions account, category
    balance_until_february = 0.0
    account.reload.transactions.pluck(:amount).map { |a| balance_until_february += a }

    travel_to "2018-03-01".to_time
    generate_transactions account, category
    balance_until_march = 0.0
    account.reload.transactions.pluck(:amount).map { |a| balance_until_march += a }

    travel_back
    generate_transactions account, category
    balance_until_now = 0.0
    account.reload.transactions.pluck(:amount).map { |a| balance_until_now += a }

    assert_equal balance_until_january, category.balance(until_date: "2018-01-31".to_time)
    assert_equal balance_until_february, category.balance(until_date: "2018-02-28".to_time)
    assert_equal balance_until_march, category.balance(until_date: "2018-03-31".to_time)
    assert_equal balance_until_now, category.balance(until_date: Time.now)
    assert_equal balance_until_now, category.balance
  end
end
