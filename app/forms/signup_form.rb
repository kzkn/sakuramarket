class SignupForm
  include ActiveModel::Model

  attr_accessor :email, :password, :password_confirmation

  validates :email, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true

  def create_user
    valid? && User.create(email: email, password: password, password_confirmation: password_confirmation)
  end
end
