module ApplicationHelper
  def column_title(model_name, column)
    t("activerecord.attributes.#{model_name}.#{column}")
  end

  def form_actions(inline: false, plain: false, &block)
    css_class = %w(form_actions)
    css_class << 'inline' if inline
    css_class << 'plain' if plain
    css_class = css_class.join(' ')
    actions = content_tag(:div, capture(&block), class: 'inner')
    actions = content_tag(:div, actions, class: css_class)
  end
end
