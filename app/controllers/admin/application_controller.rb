class Admin::ApplicationController < ApplicationController
  before_action :authenticate!, :authenticate_admin!
end
