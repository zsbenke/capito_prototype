class Category < ApplicationRecord
  include Balancable

  has_many :transactions
  validates :name, presence: true
end
