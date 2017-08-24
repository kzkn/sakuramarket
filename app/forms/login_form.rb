class LoginForm
  include ActiveModel::Model

  attr_accessor :email, :password

  def authenticate
    User.find_by(email: email)&.authenticate(password).tap do |user|
      errors.add(:email) unless user
    end
  end
end
