module ApplicationHelper
  def checkmark(value)
    value ? '&#10003;'.html_safe : ''
  end

  def labeled_yen(label, value)
    "#{label} <strong>#{number_to_currency(value)}</strong>".html_safe
  end
end
