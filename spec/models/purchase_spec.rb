require 'rails_helper'

def next_of_day(day)
  date = Date.parse(day)
  delta = Date.current < date ? 0 : 7
  date + delta
end

RSpec.describe Purchase, type: :model do
  let!(:user) { create(:user, ship_name: "Taro Sato", ship_address: "Fukuoka") }
  let!(:product) { create(:product) }
  let!(:product2) { create(:product, name: "p2", image_filename: "p2") }

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
        ship_name: "Taro Sato", ship_address: "Fukuoka",
        ship_due_date: next_of_day("Monday"), ship_due_time: "8-12"
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
        purchase.order = nil
        expect(purchase).not_to be_valid
      end
    end

    it "invalid when ship_due_date is not in candidates" do
      candidates = Purchase.ship_date_candidates
      purchase.ship_due_date = candidates[0] - 1
      expect(purchase).not_to be_valid
      purchase.ship_due_date = candidates[-1] + 1
      expect(purchase).not_to be_valid
    end

    it "invalid when ship_due_time is not in candidates" do
      purchase.ship_due_time = "7-8"
      expect(purchase).not_to be_valid
    end

    it "invalid when order is empty" do
      order.items.destroy_all
      expect(purchase).not_to be_valid
    end

    it "invalid when order is associated to no one" do
      order.user_order.destroy
      expect(purchase).not_to be_valid
    end
  end

  describe "ship_due_date" do
    def stub_now(date)
      allow(Date).to receive_message_chain(:current).and_return Date.parse(date)
    end

    it "on monday" do
      stub_now("2017-8-14")
      dates = Purchase.ship_date_candidates.map(&:to_s)
      expected = %w(
        2017/08/17 2017/08/18 2017/08/21 2017/08/22 2017/08/23
        2017/08/24 2017/08/25 2017/08/28 2017/08/29 2017/08/30
        2017/08/31 2017/09/01
      )
      expect(dates).to eq(expected)
    end

    it "on friday" do
      stub_now("2017-8-18")
      dates = Purchase.ship_date_candidates.map(&:to_s)
      expected = %w(
        2017/08/23 2017/08/24 2017/08/25 2017/08/28 2017/08/29
        2017/08/30 2017/08/31 2017/09/01 2017/09/04 2017/09/05
        2017/09/06 2017/09/07
      )
      expect(dates).to eq(expected)
    end

    it "on saturday" do
      stub_now("2017-8-19")
      dates = Purchase.ship_date_candidates.map(&:to_s)
      expected = %w(
        2017/08/23 2017/08/24 2017/08/25 2017/08/28 2017/08/29
        2017/08/30 2017/08/31 2017/09/01 2017/09/04 2017/09/05
        2017/09/06 2017/09/07
      )
      expect(dates).to eq(expected)
    end
  end
end
