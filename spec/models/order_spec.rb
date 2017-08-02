require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:user) { create(:user) }
  let!(:product) { create(:product) }
  let!(:product2) { create(:product2) }
  let!(:purchase_form) {
    PurchaseForm.new(ship_name: "a", ship_address: "b",
      ship_due_date: "2017-8-3", ship_due_time: "8-12")
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
        user.cart = cart
        cart.add_item(product, 1)

        cart2 = Order.find(cart.id)
        cart.checkout!(purchase_form)

        added = cart2.add_item(product2, 2)
        expect(added).to be_falsey
      end
    end

    describe "checkout" do
      let!(:cart) { Order.create }

      it "will succeed" do
        user.cart = cart
        cart.add_item(product, 1)
        cart.checkout!(purchase_form)
        expect(cart.purchase).to be_present
      end

      it "will fail when no one assigned to the cart" do
        cart.add_item(product, 1)
        expect { cart.checkout!(purchase_form) }.to raise_error(Order::CheckoutError)
      end

      it "will fail when no items in the cart" do
        user.cart = cart
        expect { cart.checkout!(purchase_form) }.to raise_error(Order::CheckoutError)
      end

      it "will fail when checkout twice" do
        user.cart = cart
        cart.add_item(product, 1)
        cart.checkout!(purchase_form)
        expect { cart.checkout!(purchase_form) }.to raise_error(Order::CheckoutError)
      end

      it "concurrently" do
        user.cart = cart
        cart.add_item(product, 1)
        cart2 = Order.find(cart.id)
        cart2.cart?  # purchase を強制的にロードさせる
        cart.checkout!(purchase_form)
        expect { cart2.checkout!(purchase_form) }.to raise_error(Order::CheckoutError)
      end
    end

    describe "ensure_cart_created" do
      let!(:cart) { Order.create }

      it "creates new cart" do
        cart2 = Order.ensure_cart_created(nil, nil)
        expect(cart2).not_to eq(cart)
      end

      it "reuses cart" do
        cart2 = Order.ensure_cart_created(cart, nil)
        expect(cart2).to eq(cart)
      end

      it "uses user cart" do
        user.cart = cart
        cart2 = Order.ensure_cart_created(nil, user)
        expect(cart2).to eq(cart)
      end

      it "creates new cart when user has no cart" do
        expect(user.cart).to be_blank
        cart2 = Order.ensure_cart_created(nil, user)
        expect(cart2).not_to eq(cart)
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
        cart.add_item(product, 1)
        cart2 = user.orders.create
        cart2.add_item(product, 3)
        cart2.add_item(product2, 2)

        merged = cart.merge_or_assign(user)
        expect(Order.find_by(id: cart.id)).to be_blank  # move 元 (= cart) は消える
        expect(merged).to eq(user.cart)  # move 先 (= user.cart) と一致する

        expect(merged.items.size).to eq(2)
        merged.items.first.tap do |item|
          expect(item.product).to eq(product)
          expect(item.quantity).to eq(4)
        end
        merged.items.second.tap do |item|
          expect(item.product).to eq(product2)
          expect(item.quantity).to eq(2)
        end
      end
    end
  end
end
