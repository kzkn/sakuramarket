require 'rails_helper'

RSpec.feature "Carts", type: :feature do
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

  describe "delete", js: true do
    let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test.jpg")) }

    before do
      p1.update!(image_file: file)
      put_into_cart(p1)
    end

    it "deletes product from cart" do
      visit("/cart")
      page.accept_confirm "カートから削除します。よろしいですか？" do
        click_link("削除")
      end
      expect(page).to have_content("カートから商品を削除しました。")
      expect(page).not_to have_content(p1.name)
    end
  end

  context "logged in" do
    let!(:user) { User.create!(email: "a@a.com", password: "hidebu", password_confirmation: "hidebu") }

    before { do_login }

    it "go to orders history" do
      visit("/cart")
      click_link("過去の注文履歴を見る")
      expect(page).to have_current_path(orders_path)
    end

    context "not empty" do
      before do
        put_into_cart(p1)
        put_into_cart(p2)
      end

      it "go to purchase" do
        visit("/cart")
        click_link("レジに進む")
        expect(page).to have_current_path(new_order_path)
      end
    end

    context "emtpy" do
      it "does not show purchase link" do
        visit("/cart")
        expect(page).not_to have_link("レジに進む")
      end
    end
  end
end
