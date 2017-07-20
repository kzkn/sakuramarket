module ApplicationHelper
  def checkmark(value)
    value ? '&#10003;'.html_safe : ''
  end

  def yen(value)
    "￥#{value}"
  end
end
