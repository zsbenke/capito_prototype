require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  test "should validate transaction" do
    transaction = Transaction.new

    refute transaction.valid?
    assert transaction.errors.messages[:category].present?
    assert transaction.errors.messages[:account].present?
    assert transaction.errors.messages[:amount].present?
  end
end
