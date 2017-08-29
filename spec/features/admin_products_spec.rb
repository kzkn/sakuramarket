require 'rails_helper'

CHECKMARK = "\u2713"  # = &#10003;

RSpec.feature "AdminProducts", type: :feature do
  let!(:admin) { User.create!(email: "a@a.com", password: "hidebu", password_confirmation: "hidebu", admin: true) }
  let!(:apple) { create(:product) }
  let!(:melon) { create(:product, name: "melon", image_filename: "melon.jpg") }

  before { do_login(admin) }

  scenario "lists all products" do
    visit admin_products_path
    expect(page.all("table tr").size).to eq 3  # 2 products, 1 header
  end

  scenario "shows product detail" do
    visit admin_product_path(melon)
    expect(page).to have_selector "img[src='#{melon.image_path}']"
    expect(page).to have_content melon.name
    expect(page).to have_content melon.price
    expect(page).to have_content melon.description
    expect(page).not_to have_content CHECKMARK
  end

  scenario "edits product" do
    visit edit_admin_product_path(melon)
    fill_in "商品名", with: "banana"
    fill_in "価格", with: 999
    fill_in "説明", with: "Fresh Banana!"
    check "非表示"
    click_button "保存"

    expect(page).to have_current_path admin_product_path(melon)
    expect(page).to have_selector "img[src='#{melon.image_path}']"
    expect(page).to have_content "banana"
    expect(page).to have_content "999"
    expect(page).to have_content "Fresh Banana!"
    expect(page).to have_content CHECKMARK
  end

  scenario "creates product" do
    visit new_admin_product_path
    fill_in "商品名", with: "lemon"
    attach_file "商品画像", Rails.root.join("spec/fixtures/test.jpg")
    fill_in "価格", with: 888
    fill_in "説明", with: "Fresh Lemon!!!"
    click_button "保存"

    p3 = Product.last
    expect(page).to have_current_path admin_product_path(p3)
    expect(page).to have_selector "img[src='#{p3.image_path}']"
    expect(page).to have_content "lemon"
    expect(page).to have_content "888"
    expect(page).to have_content "Fresh Lemon!!!"
    expect(page).not_to have_content CHECKMARK
  end
end
