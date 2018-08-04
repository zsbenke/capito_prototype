Rails.application.routes.draw do
  resources :budgets, only: :index do
    resources :budget_balances, only: [:update, :edit], module: :budgets
  end
  resources :transactions, only: [:index, :new, :edit, :create, :update, :destroy]
end
