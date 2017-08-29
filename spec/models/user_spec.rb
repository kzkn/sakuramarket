require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validation" do
    let!(:user) { User.new(email: "a@a.com", password_digest: "a", ship_name: "b", ship_address: "c") }

    it "valid" do
      expect(user).to be_valid
    end

    it "invalid when email is blank" do
      user.email = nil
      expect(user).not_to be_valid
    end

    it "invalid when password_digest is blank" do
      user.password_digest = nil
      expect(user).not_to be_valid
    end

    it "valid when ship_name is blank" do
      user.ship_name = nil
      expect(user).to be_valid
    end

    it "valid when ship_address is blank" do
      user.ship_address = nil
      expect(user).to be_valid
    end

    it "invalid when email is not unique" do
      User.create(email: user.email, password_digest: "a", ship_name: "b", ship_address: "c")
      expect(user).not_to be_valid
    end
  end
end
