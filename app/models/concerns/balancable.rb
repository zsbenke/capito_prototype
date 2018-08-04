module Balancable
  extend ActiveSupport::Concern

  included do
    def balance(start_date: nil, until_date: nil)
      return nil unless respond_to? :transactions
      transactions_for_balance = transactions
      if start_date.respond_to?(:beginning_of_day)
        until_date = until_date.beginning_of_day
        transactions_for_balance = transactions_for_balance.where("created_at >= ?", start_date)
      end

      if until_date.respond_to?(:end_of_day)
        until_date = until_date.end_of_day
        transactions_for_balance = transactions_for_balance.where("created_at <= ?", until_date)
      end
      transactions_for_balance.sum(:amount)
    end
  end
end

