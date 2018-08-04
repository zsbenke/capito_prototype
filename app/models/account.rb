class Account < ApplicationRecord
  has_many :transactions

  validates :name, presence: true

  def balance
    self.transactions.sum(:amount)
  end
end
