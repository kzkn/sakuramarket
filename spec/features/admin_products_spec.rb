require 'rails_helper'

CHECKMARK = "\u2713"  # = &#10003;

RSpec.feature "AdminProducts", type: :feature do
  let!(:admin) { User.create!(email: "a@a.com", password: "hidebu", password_confirmation: "hidebu", admin: true) }
  let!(:p1) { create(:product) }
  let!(:p2) { create(:product2) }

  def do_login
    visit("/login")
    fill_in("メールアドレス", with: "a@a.com")
    fill_in("パスワード", with: "hidebu")
    click_button("ログイン")
  end

  before { do_login }

  it "lists all products" do
    visit("/admin/products")
    expect(page.all("table tr").size).to eq(3)  # 2 products, 1 header
  end

  it "shows product detail" do
    visit(admin_product_path(p2))
    expect(page).to have_selector("img[src='#{p2.image_path}']")
    expect(page).to have_content(p2.name)
    expect(page).to have_content(p2.price)
    expect(page).to have_content(p2.description)
    expect(page).not_to have_content(CHECKMARK)
  end

  it "edits product" do
    visit(edit_admin_product_path(p2))
    fill_in("商品名", with: "hogehoge")
    fill_in("価格", with: 999)
    fill_in("説明", with: "fugafuga")
    check "非表示"
    click_button "保存"

    expect(page).to have_current_path(admin_product_path(p2))
    expect(page).to have_selector("img[src='#{p2.image_path}']")
    expect(page).to have_content("hogehoge")
    expect(page).to have_content("999")
    expect(page).to have_content("fugafuga")
    expect(page).to have_content(CHECKMARK)
  end

  it "creates product" do
    visit(new_admin_product_path)
    fill_in("商品名", with: "foo")
    attach_file("商品画像", Rails.root.join("spec/fixtures/test.jpg"))
    fill_in("価格", with: 888)
    fill_in("説明", with: "bar")
    click_button("保存")

    p3 = Product.last
    expect(page).to have_current_path(admin_product_path(p3))
    expect(page).to have_selector("img[src='#{p3.image_path}']")
    expect(page).to have_content("foo")
    expect(page).to have_content("888")
    expect(page).to have_content("bar")
    expect(page).not_to have_content(CHECKMARK)
  end
end
