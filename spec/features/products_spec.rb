require 'rails_helper'

RSpec.feature "Products", type: :feature do
  let!(:apple) { create(:product) }

  it "shows product" do
    visit product_path(apple)
    expect(page).to have_content apple.name
    expect(page).to have_content "#{apple.price}円"
    expect(page).to have_content apple.description
  end

  it "puts into cart" do
    visit product_path(apple)
    click_button "カートに入れる"
    expect(page).to have_current_path cart_path
    expect(page).to have_content "商品をカートに追加しました。"
    expect(page).to have_content apple.name
  end
end
