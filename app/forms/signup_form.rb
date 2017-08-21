class SignupForm
  include ActiveModel::Model

  attr_accessor :email, :password, :password_confirmation

  validates :email, presence: true, email: true
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true

  def create_user
    user = User.new(email: email, password: password, password_confirmation: password_confirmation)
    if valid? && user.save
      user
    else
      nil
    end
  end
end
