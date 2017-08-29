require 'rails_helper'

RSpec.describe LineItem, type: :model do
  describe "validation" do
    let!(:order) { Order.create }
    let!(:apple) { create(:product) }
    let!(:line_item) { LineItem.new(order: order, product: apple, price: 1, quantity: 2) }

    it "valid" do
      expect(line_item).to be_valid
    end

    it "invalid when order is blank" do
      line_item.order = nil
      expect(line_item).not_to be_valid
    end

    it "invalid when product is blank" do
      line_item.product = nil
      expect(line_item).not_to be_valid
    end

    it "invalid when price is blank" do
      line_item.price = nil
      expect(line_item).not_to be_valid
    end

    it "invalid when quantity is blank" do
      line_item.quantity = nil
      expect(line_item).not_to be_valid
    end

    it "invalid when price is not a number" do
      line_item.price = "a"
      expect(line_item).not_to be_valid
    end

    it "invalid when quantity is not a number" do
      line_item.quantity = "a"
      expect(line_item).not_to be_valid
    end

    it "invalid when price is not a integer" do
      line_item.price = 1.1
      expect(line_item).not_to be_valid
    end

    it "invalid when quantity is not a integer" do
      line_item.quantity = 1.1
      expect(line_item).not_to be_valid
    end
  end
end
