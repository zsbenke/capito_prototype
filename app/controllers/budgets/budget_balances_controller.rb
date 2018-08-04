class Budgets::BudgetBalancesController < ApplicationController
  include Budgetable
  before_action :set_budget, only: :update
  before_action :set_budget_balance, only: :update

  def update
    @budget_balance.update(budget_balance_params)
    respond_to do |format|
      format.js
    end
  end

  private

  def set_budget_balance
    @budget_balance = BudgetBalance.find(params[:id])
  end

  def budget_balance_params
    params.require(:budget_balance).permit(:budgeted)
  end
end
