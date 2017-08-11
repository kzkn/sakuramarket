require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validation" do
    let!(:user) { User.new(email: "a@a.com", password_digest: "a", ship_name: "b", ship_address: "c") }

    it "valid" do
      expect(user).to be_valid
    end

    %w(email password_digest).each do |field|
      it "invalid when #{field} is blank" do
        user.send("#{field}=", nil)
        expect(user).not_to be_valid
      end
    end

    %w(ship_name ship_address).each do |field|
      it "valid when #{field} is blank" do
        user.send("#{field}=", nil)
        expect(user).to be_valid
      end
    end

    it "invalid when email is not unique" do
      User.create(email: user.email, password_digest: "a", ship_name: "b", ship_address: "c")
      expect(user).not_to be_valid
    end
  end
end
