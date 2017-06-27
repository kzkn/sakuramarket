# -*- coding: utf-8 -*-
class LogoutController < ApplicationController
  def create
    authenticated nil
    redirect_to login_path, notice: "ログアウトしました。"
  end
end
