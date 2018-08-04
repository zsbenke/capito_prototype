require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "should validate account" do
    account = Account.new

    refute account.valid?
    assert account.errors.messages[:name].present?
  end
end
