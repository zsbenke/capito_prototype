module BudgetBalancesHelper
  def text_field_for_budget_balance_budgeted(budget_balance)
    budgeted = budget_balance.budgeted == 0.0 ? nil : budget_balance.budgeted
    if budgeted.to_i.to_f == budgeted
      budgeted = budgeted.to_i
    end

    text_field_tag 'budget_balance[budgeted]', budgeted, autocomplete: :off,
      data: {
        remote: true,
        url: budget_budget_balance_path(budget_id: 1, id: budget_balance.id, current_month: params[:current_month]),
        method: :put
      }
  end
end
