require 'rails_helper'

RSpec.describe UserOrder, type: :model do
  describe "validation" do
    let!(:order) { Order.create }
    let!(:user) { create(:user) }
    let!(:user_order) { UserOrder.new(order: order, user: user) }

    it "valid" do
      expect(user_order).to be_valid
    end

    it "invalid when order is blank" do
      user_order.order = nil
      expect(user_order).not_to be_valid
    end

    it "invalid when user is blank" do
      user_order.user = nil
      expect(user_order).not_to be_valid
    end

    it "invalid when order is not unique" do
      UserOrder.create(order: order, user: create(:user, email: "bar@bar.com"))
      expect(user_order).not_to be_valid
    end
  end
end
