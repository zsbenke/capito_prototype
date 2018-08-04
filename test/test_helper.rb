ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def random_amount
    AmountGenerator.new.amount
  end
end

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

