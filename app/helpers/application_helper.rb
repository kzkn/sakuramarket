module ApplicationHelper
  def checkmark(value)
    value ? '&#10003;'.html_safe : ''
  end

  def yen(value)
    "￥#{value}"
  end

  def labeled_yen(label, value)
    "#{label} <strong>#{yen(value)}</strong>".html_safe
  end
end
