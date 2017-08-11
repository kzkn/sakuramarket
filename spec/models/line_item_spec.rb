require 'rails_helper'

RSpec.describe LineItem, type: :model do
  describe "validation" do
    let!(:order) { Order.create }
    let!(:product) { create(:product) }
    let!(:line_item) { LineItem.new(order: order, product: product, price: 1, quantity: 2) }

    it "valid" do
      expect(line_item).to be_valid
    end

    %w(order product price quantity).each do |field|
      it "invalid when #{field} is blank" do
        line_item.send("#{field}=", nil)
        expect(line_item).not_to be_valid
      end
    end

    %w(price quantity).each do |field|
      it "invalid when #{field} is not a number" do
        line_item.send("#{field}=", "a")
        expect(line_item).not_to be_valid
      end

      it "invalid when #{field} is not a integer" do
        line_item.send("#{field}=", 1.1)
        expect(line_item).not_to be_valid
      end
    end
  end
end
