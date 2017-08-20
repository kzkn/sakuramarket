class Admin::HomeController < ApplicationController
  before_action :authenticate!, :authenticate_admin!

  def show
  end
end
