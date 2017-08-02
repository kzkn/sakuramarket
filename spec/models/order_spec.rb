require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:user) { User.create(email: "foo@foo.com", password_digest: "p") }
  let!(:product) {
    Product.create(name: "p1", image_filename: "img", price: 100,
      description: "p1", hidden: false)
  }
  let!(:product2) {
    Product.create(name: "p2", image_filename: "img", price: 100,
      description: "p2", hidden: false)
  }

  describe "cart" do
    describe "add_item" do
      let!(:cart) { Order.create }

      it "adds as new line item" do
        cart.add_item(product, 1)
        expect(cart.items.size).to eq(1)
        cart.items.first.tap do |item|
          expect(item.product).to eq(product)
          expect(item.quantity).to eq(1)
          expect(item.price).to eq(100)
        end
      end

      it "updates already added line item" do
        cart.add_item(product, 1)
        cart.add_item(product, 2)
        expect(cart.items.size).to eq(1)
        cart.items.first.tap do |item|
          expect(item.product).to eq(product)
          expect(item.quantity).to eq(3)
          expect(item.price).to eq(100)
        end
      end

      it "adds as new item if price changed" do
        cart.add_item(product, 1)
        product.update(price: 200)
        cart.add_item(product, 2)

        expect(cart.items.size).to eq(2)
        cart.items.first.tap do |item|
          expect(item.product).to eq(product)
          expect(item.quantity).to eq(1)
          expect(item.price).to eq(100)
        end
        cart.items.second.tap do |item|
          expect(item.product).to eq(product)
          expect(item.quantity).to eq(2)
          expect(item.price).to eq(200)
        end
      end

      it "concurrently" do
        cart2 = Order.find(cart.id)
        cart.add_item(product, 1)
        cart2.add_item(product2, 1)

        cart.reload
        expect(cart.items.size).to eq(2)
      end

      it "concurrently with checkout" do
        cart.update!(user: user)
        cart.add_item(product, 1)

        cart2 = Order.find(cart.id)
        cart.checkout!(PurchaseForm.new(
          ship_name: "a", ship_address: "b",
          ship_due_date: "2017-8-3", ship_due_time: "8-12"))

        added = cart2.add_item(product2, 2)
        expect(added).to be_falsey
      end
    end
  end
end
