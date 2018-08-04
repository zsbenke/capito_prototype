module Budgetable
  extend ActiveSupport::Concern

  included do
    private

    def set_budget
      @budget = Budget.new(current_month: current_month)
    end

    def current_month
      initial_month = Date.current.strftime("%Y-%m-%d").to_date
      raw_month = params.fetch(:current_month, initial_month)
      begin
        DateTime.strptime(raw_month, "%Y-%m-%d").strftime("%Y-%m-%d").to_date
      rescue
        initial_month
      end
    end
  end
end
