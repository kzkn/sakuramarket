require 'rails_helper'

RSpec.describe Purchase, type: :model do
  let!(:user) { create(:user) }
  let!(:product) { create(:product) }
  let!(:product2) { create(:product2) }

  describe "cod_cost" do
    let!(:cart) { user.orders.create }

    it "is 300yen when subtotal < 10000" do
      product.update(price: 9999)
      cart.add_item(product, 1)
      expect(Purchase.cod_cost(cart)).to eq(300)
    end

    [10000, 29999].each do |price|
      it "is 400yen when subtotal = #{price}" do
        product.update(price: price)
        cart.add_item(product, 1)
        expect(Purchase.cod_cost(cart)).to eq(400)
      end
    end

    [30000, 99999].each do |price|
      it "is 600yen when subtotal = #{price}" do
        product.update(price: price)
        cart.add_item(product, 1)
        expect(Purchase.cod_cost(cart)).to eq(600)
      end
    end

    it "is 600yen when 100000 <= subtotal" do
      product.update(price: 100000)
      cart.add_item(product, 1)
      expect(Purchase.cod_cost(cart)).to eq(1000)
    end
  end

  describe "ship_cost" do
    let!(:cart) { user.orders.create }

    [1, 5].each do |quantity|
      it "is 600yen when quantity = #{quantity}" do
        cart.add_item(product, quantity)
        expect(Purchase.ship_cost(cart)).to eq(600)
      end
    end

    [6, 10].each do |quantity|
      it "is 1200yen when quantity = #{quantity}" do
        cart.add_item(product, quantity)
        expect(Purchase.ship_cost(cart)).to eq(1200)
      end
    end
  end

  describe "total" do
    let!(:cart) { user.orders.create }

    it "is 5940yen" do
      product.update!(price: 800)
      product2.update!(price: 400)
      cart.add_item(product, 4)
      cart.add_item(product2, 2)

      expect(cart.subtotal).to eq(4000)
      expect(cart.total_quantity).to eq(6)
      expect(Purchase.total(cart)).to eq(5940)
    end
  end

  describe "validation" do
    let!(:order) do
      order = user.orders.create
      order.add_item(product, 1)
      order
    end
    let!(:purchase) {
      order.build_purchase(
        ship_name: "a", ship_address: "b",
        ship_due_date: "2017-8-11", ship_due_time: "8-12"
      )
    }

    it "valid" do
      expect(purchase).to be_valid
    end

    %w(ship_name ship_address ship_due_date ship_due_time).each do |field|
      it "invalid when #{field} is blank" do
        purchase.send("#{field}=", nil)
        expect(purchase).not_to be_valid
      end
    end

    %w(tax_rate cod_cost ship_cost total).each do |field|
      it "invalid when #{field} is not a number" do
        purchase.send("#{field}=", "a")
        expect(purchase).not_to be_valid
      end
    end
  end
end
