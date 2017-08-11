require 'rails_helper'

RSpec.describe Ordering, type: :model do
  describe "validation" do
    let!(:order) { Order.create }
    let!(:user) { create(:user) }
    let!(:ordering) { Ordering.new(order: order, user: user) }

    it "valid" do
      expect(ordering).to be_valid
    end

    %w(order user).each do |field|
      it "invalid when #{field} is blank" do
        ordering.send("#{field}=", nil)
        expect(ordering).not_to be_valid
      end
    end

    it "invalid when order is not unique" do
      Ordering.create(order: order ,user: user)
      expect(ordering).not_to be_valid
    end
  end
end
