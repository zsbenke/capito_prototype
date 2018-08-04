module BudgetsHelper
  def balance_tag(amount)
    css_class = 'balance_number '
    if amount > 0
      css_class << 'positive'
    elsif amount < 0
      css_class << 'negative'
    end
    if amount.to_i.to_f != amount
      tag.span(class: css_class) {  number_to_currency(amount.round(2), precision: 2) }
    else
      tag.span(class: css_class) {  number_to_currency(amount) }
    end
  end

  def previous_month_link(budget)
    previous_month = budget.current_month - 1.month
    month_pager_link "&larr; #{l(previous_month, format: :year_and_month)}".html_safe, previous_month
  end

  def next_month_link(budget)
    next_month = budget.current_month + 1.month
    month_pager_link "#{l(next_month, format: :year_and_month)} &rarr;".html_safe, next_month
  end

  def month_pager_link(text, month)
    link_to text, budgets_path(current_month: month)
  end
end
