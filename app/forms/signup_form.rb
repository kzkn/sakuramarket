class SignupForm
  include ActiveModel::Model

  attr_accessor :email, :password, :password_confirmation

  validates :email, presence: true, email: true
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true

  def create_user
    valid? && User.create(email: email, password: password, password_confirmation: password_confirmation)
  end
end
