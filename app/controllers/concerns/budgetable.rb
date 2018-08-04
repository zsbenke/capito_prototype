module Budgetable
  extend ActiveSupport::Concern

  included do
    private

    def set_budget
      @budget = Budget.new(current_month: current_month)
    end

    def current_month
      initial_month = Date.current
      raw_month = params.fetch(:current_month, initial_month)
      begin
        raw_month.strptime("%Y-%m-%d")
      rescue
        initial_month
      end
    end
  end
end
