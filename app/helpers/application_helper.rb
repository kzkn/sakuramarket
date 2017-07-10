# -*- coding: utf-8 -*-
module ApplicationHelper
  def checkmark(flag)
    flag ? '&#10003;'.html_safe : ''
  end

  def yen(price)
    "￥#{price}"
  end

  def labeled_price(label, price)
    content_tag(:p, class: 'product__price') do
      (tag.span "#{label} ") + content_tag(:span, class: 'product__price_value') do
        tag.strong yen(price)
      end
    end
  end

  def format_datetime(dt)
    dt.in_time_zone('Asia/Tokyo').iso8601
  end
end
