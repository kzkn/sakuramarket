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
end
