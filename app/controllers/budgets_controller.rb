class BudgetsController < ApplicationController
  include Budgetable
  before_action :set_budget, only: :index

  def index; end
end
