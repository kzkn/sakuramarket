require 'rails_helper'

RSpec.describe Purchase, type: :model do
  let!(:user) { create(:user, ship_name: "Taro Sato", ship_address: "Fukuoka") }
  let!(:apple) { create(:product) }
  let!(:melon) { create(:product, name: "melon", image_filename: "melon.jpg") }

  describe "cod_cost" do
    let!(:cart) { user.orders.create }

    it "is 300yen when subtotal < 10000" do
      apple.update(price: 9999)
      cart.add_item(apple, 1)
      expect(Purchase.cod_cost(cart)).to eq 300
    end

    [10000, 29999].each do |price|
      it "is 400yen when subtotal = #{price}" do
        apple.update(price: price)
        cart.add_item(apple, 1)
        expect(Purchase.cod_cost(cart)).to eq 400
      end
    end

    [30000, 99999].each do |price|
      it "is 600yen when subtotal = #{price}" do
        apple.update(price: price)
        cart.add_item(apple, 1)
        expect(Purchase.cod_cost(cart)).to eq 600
      end
    end

    it "is 600yen when 100000 <= subtotal" do
      apple.update(price: 100000)
      cart.add_item(apple, 1)
      expect(Purchase.cod_cost(cart)).to eq 1000
    end
  end

  describe "ship_cost" do
    let!(:cart) { user.orders.create }

    [1, 5].each do |quantity|
      it "is 600yen when quantity = #{quantity}" do
        cart.add_item(apple, quantity)
        expect(Purchase.ship_cost(cart)).to eq 600
      end
    end

    [6, 10].each do |quantity|
      it "is 1200yen when quantity = #{quantity}" do
        cart.add_item(apple, quantity)
        expect(Purchase.ship_cost(cart)).to eq 1200
      end
    end
  end

  describe "total" do
    let!(:cart) { user.orders.create }

    it "is 5940yen" do
      apple.update!(price: 800)
      melon.update!(price: 400)
      cart.add_item(apple, 4)
      cart.add_item(melon, 2)

      expect(cart.subtotal).to eq 4000
      expect(cart.total_quantity).to eq 6
      expect(Purchase.total(cart)).to eq 5940
    end
  end

  describe "validation" do
    let!(:order) do
      user.orders.create.tap do |order|
        order.add_item(apple, 1)
      end
    end
    let!(:purchase) {
      valid_ship_due_date = Purchase.ship_date_candidates[0]
      valid_ship_due_time = Purchase::SHIP_TIME_CANDIDATES[0]
      order.build_purchase(
        ship_name: "Taro Sato", ship_address: "Fukuoka",
        ship_due_date: valid_ship_due_date,
        ship_due_time: valid_ship_due_time
      )
    }

    it "valid" do
      expect(purchase).to be_valid
    end

    it "invalid when ship_name is blank" do
      purchase.ship_name = nil
      expect(purchase).not_to be_valid
    end

    it "invalid when ship_address is blank" do
      purchase.ship_address = nil
      expect(purchase).not_to be_valid
    end

    it "invalid when ship_due_date is blank" do
      purchase.ship_due_date = nil
      expect(purchase).not_to be_valid
    end

    it "invalid when ship_due_time is blank" do
      purchase.ship_due_time = nil
      expect(purchase).not_to be_valid
    end

    it "invalid when order is blank" do
      purchase.order = nil
      expect(purchase).not_to be_valid
    end

    it "invalid when order.user is blank" do
      purchase.order.user = nil
      expect(purchase).not_to be_valid
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

  describe "ship_date_candidates" do
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
      expect(dates).to eq expected
    end

    it "on friday" do
      stub_now("2017-8-18")
      dates = Purchase.ship_date_candidates.map(&:to_s)
      expected = %w(
        2017/08/23 2017/08/24 2017/08/25 2017/08/28 2017/08/29
        2017/08/30 2017/08/31 2017/09/01 2017/09/04 2017/09/05
        2017/09/06 2017/09/07
      )
      expect(dates).to eq expected
    end

    it "on saturday" do
      stub_now("2017-8-19")
      dates = Purchase.ship_date_candidates.map(&:to_s)
      expected = %w(
        2017/08/23 2017/08/24 2017/08/25 2017/08/28 2017/08/29
        2017/08/30 2017/08/31 2017/09/01 2017/09/04 2017/09/05
        2017/09/06 2017/09/07
      )
      expect(dates).to eq expected
    end
  end
end
