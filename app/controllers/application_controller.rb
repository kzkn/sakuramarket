class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    nil  # TODO
  end

  def current_cart
    @cart ||= Order.find_by(id: session[:cart_id])
  end

  def set_current_cart(cart)
    session[:cart_id] = cart.id
  end

  def ensure_cart_created
    Order.ensure_cart_created(current_cart, current_user).tap do |cart|
      set_current_cart cart
    end
  end
end
