require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:user) { create(:user) }
  let!(:apple) { create(:product) }
  let!(:melon) { create(:product, name: "melon", image_filename: "melon.jpg") }

  describe "cart" do
    describe "add_item" do
      let!(:cart) { Order.create }

      it "adds as new line item" do
        cart.add_item(apple, 1)
        expect(cart.items.size).to eq 1
        cart.items.first.tap do |item|
          expect(item.product).to eq apple
          expect(item.quantity).to eq 1
          expect(item.price).to eq 100
        end
      end

      it "updates already added line item" do
        cart.add_item(apple, 1)
        cart.add_item(apple, 2)
        expect(cart.items.size).to eq 1
        cart.items.first.tap do |item|
          expect(item.product).to eq apple
          expect(item.quantity).to eq 3
          expect(item.price).to eq 100
        end
      end

      it "adds as new item if price changed" do
        cart.add_item(apple, 1)
        apple.update(price: 200)
        cart.add_item(apple, 2)

        expect(cart.items.size).to eq 2
        cart.items.first.tap do |item|
          expect(item.product).to eq apple
          expect(item.quantity).to eq 1
          expect(item.price).to eq 100
        end
        cart.items.second.tap do |item|
          expect(item.product).to eq apple
          expect(item.quantity).to eq 2
          expect(item.price).to eq 200
        end
      end

      it "concurrently" do
        cart2 = Order.find(cart.id)
        cart.add_item(apple, 1)
        cart2.add_item(melon, 1)

        cart.reload
        expect(cart.items.size).to eq 2
      end
    end

    describe "get_or_create_cart_for" do
      let!(:cart) { Order.create }

      it "creates new cart" do
        cart2 = Order.get_or_create_cart_for(nil)
        expect(cart2).not_to eq cart
      end

      it "uses user cart" do
        user.cart = cart
        cart2 = Order.get_or_create_cart_for(user)
        expect(cart2).to eq cart
      end

      it "creates new cart when user has no cart" do
        expect(user.cart).to be_blank
        cart2 = Order.get_or_create_cart_for(user)
        expect(cart2).not_to eq cart
      end
    end

    describe "merge_or_assign" do
      let!(:cart) { Order.create }

      it "assigns to user" do
        expect(user.cart).to be_blank
        cart.merge_or_assign(user)
        expect(user.cart).to be_present
      end

      it "merges 2 carts" do
        cart.add_item(apple, 1)
        cart2 = user.orders.create
        cart2.add_item(apple, 3)
        cart2.add_item(melon, 2)

        merged = cart.merge_or_assign(user)
        expect(Order.find_by(id: cart.id)).to be_blank  # move 元 (= cart) は消える
        expect(merged).to eq user.cart  # move 先 (= user.cart と一致する

        expect(merged.items.size).to eq 2
        merged.items.first.tap do |item|
          expect(item.product).to eq apple
          expect(item.quantity).to eq 4
        end
        merged.items.second.tap do |item|
          expect(item.product).to eq melon
          expect(item.quantity).to eq 2
        end
      end
    end
  end
end
