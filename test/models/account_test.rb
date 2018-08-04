require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  class AmountGenerator
    attr_reader :amount

    def initialize
      @amount = rand(10000)
      @amount =  -(amount.abs) if negative?
    end

    private

    def negative?
      rand(2) == 1 ? true : false
    end
  end

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
      random_amount = AmountGenerator.new.amount
      transaction = Transaction.create(
        category: category,
        amount: random_amount,
        account: account
      )
      assert transaction.valid?
      balance_assertion += random_amount
    end

    assert_equal balance_assertion, account.balance
  end
end
