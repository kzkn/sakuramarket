class Form::Login
  include ActiveModel::Model

  attr_accessor :account, :password

  def user
    User.find_by(email_address: account).try(:authenticate, password)
  end
end
