require 'rails_helper'

RSpec.describe UserOrder, type: :model do
  describe "validation" do
    let!(:order) { Order.create }
    let!(:user) { create(:user) }
    let!(:user_order) { UserOrder.new(order: order, user: user) }

    it "valid" do
      expect(user_order).to be_valid
    end

    %w(order user).each do |field|
      it "invalid when #{field} is blank" do
        user_order.send("#{field}=", nil)
        expect(user_order).not_to be_valid
      end
    end

    it "invalid when order is not unique" do
      UserOrder.create(order: order ,user: user)
      expect(user_order).not_to be_valid
    end
  end
end
