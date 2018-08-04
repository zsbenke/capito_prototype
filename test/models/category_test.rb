require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "should validate category" do
    category = Category.new

    refute category.valid?
    assert category.errors.messages[:name].present?
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
end
