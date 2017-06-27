class Form::Login
  include ActiveModel::Model

  attr_accessor :account, :password

  validates :account, presence: true
  validates :password, presence: true

  def user
    valid? && User.authenticate(account, password)
  end
end
