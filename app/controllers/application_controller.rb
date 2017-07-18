class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :exception

  def authenticate!
    unless current_user
      redirect_to_login
    end
  end

  def authenticate_admin!
    unless current_user && current_user.admin?
      redirect_to_login
    end
  end

  def redirect_to_login
    session[:after_login_path] = request.path
    redirect_to login_path
  end

  def log_in(user)
    session[:user_id] = user.id
    if current_cart
      if user.cart
        set_current_cart(current_cart.move_items_to(user.cart))
      else
        current_cart.update!(user: user)
      end
    end
  end

  def log_out
    unset_current_cart
    session.delete(:user_id)
    @current_user = nil
  end

  def set_current_cart(cart)
    session[:cart_id] = cart.id
  end

  def unset_current_cart
    session.delete(:cart_id)
    @current_cart = nil
  end

  def current_cart
    @current_cart ||= Order.find_by(id: session[:cart_id])
  end

  def ensure_cart_created
    unless current_cart.try(:owner?, current_user)
      cart = current_user&.cart
      cart = current_user&.orders&.create(cod_fee: 0, ship_fee: 0, ship_to_name: '', ship_to_address: '', ship_date: Date.current, ship_period: '') unless cart  # TODO 仮実装
      cart = Order.create unless cart
      set_current_cart(cart)
    end
    current_cart
  end
end
