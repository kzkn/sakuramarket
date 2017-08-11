require 'rails_helper'

RSpec.feature "Orders", type: :feature do
  let!(:user) { User.create!(email: "a@a.com", password: "hidebu", password_confirmation: "hidebu") }
  let!(:p1) { create(:product) }
  let!(:p2) { create(:product2) }

  def put_into_cart(product)
    visit(product_path(product))
    click_button("カートに入れる")
  end

  def do_login
    visit("/login")
    fill_in("メールアドレス", with: "a@a.com")
    fill_in("パスワード", with: "hidebu")
    click_button("ログイン")
  end

  describe "purchase" do
    before do
      do_login
      put_into_cart(p1)
      put_into_cart(p2)
    end

    it "accepts new order" do
      visit("/orders/new")
      fill_in("送り先氏名", with: "z")
      fill_in("送り先住所", with: "y")
      click_button("注文する")

      expect(page).to have_content("注文を受け付けました。")
    end
  end

  describe "history" do
    def purchase(product)
      put_into_cart(product)
      visit("/orders/new")
      fill_in("送り先氏名", with: "z")
      fill_in("送り先住所", with: "y")
      click_button("注文する")
    end

    before do
      do_login
      purchase(p1)
      purchase(p2)
      put_into_cart(p1)
    end

    it "lists completed order history" do
      visit("/orders")
      expect(page.all("table tr").size).to eq(3)  # 2 orders + 1 header
    end

    it "shows order detail" do
      order = user.orders.only_checked.first
      visit(order_path(order))
      expect(page).to have_content(order.purchase.ship_name)
      expect(page).to have_content(order.purchase.ship_address)
      expect(page).to have_content(order.purchase.ship_due_date)
      expect(page).to have_content(order.purchase.ship_due_time)
    end
  end
end
