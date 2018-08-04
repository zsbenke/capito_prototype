$("#<%= dom_id(@budget_balance) %>").replaceWith("<%= j render @budget_balance %>")
$("#available_for_budget").replaceWith("<%= j render 'budgets/available_for_budget', budget: @budget %>")
