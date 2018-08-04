require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "should validate category" do
    category = Category.new

    refute category.valid?
    assert category.errors.messages[:name].present?
  end
end
