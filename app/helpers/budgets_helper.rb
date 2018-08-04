module BudgetsHelper
  def balance_tag(amount)
    css_class = 'balance_number '
    if amount > 0
      css_class << 'positive'
    elsif amount < 0
      css_class << 'negative'
    end
    tag.span(class: css_class) {  number_to_currency(amount) }
  end
end
