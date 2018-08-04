require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "should validate account" do
    account = Account.new

    refute account.valid?
    assert account.errors.messages[:name].present?
  end

  test "should calculate account balance" do
    account = accounts :otp_smart
    balance_assertion = 0

    assert_equal 0, account.balance

    10.times do
      category = Category.order(Arel.sql("RANDOM()")).limit(Category.count).first
      transaction = Transaction.create(
        account: account,
        category: category,
        amount: random_amount
      )
      assert transaction.valid?
      balance_assertion += transaction.amount
    end

    assert_equal balance_assertion, account.balance
  end
end
