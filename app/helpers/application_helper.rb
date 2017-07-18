module ApplicationHelper
  def checkmark(value)
    value ? '&#10003;'.html_safe : ''
  end
end
