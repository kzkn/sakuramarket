class HomeController < ApplicationController
  def index
    @products = Product.for_display
  end
end
