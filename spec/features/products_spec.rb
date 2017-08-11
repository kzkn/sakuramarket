require 'rails_helper'

RSpec.feature "Products", type: :feature do
  let!(:p1) { create(:product) }

  it "shows product" do
    visit(product_path(p1))
    expect(page).to have_content(p1.name)
    expect(page).to have_content("￥#{p1.price}")
    expect(page).to have_content(p1.description)
  end

  it "puts into cart" do
    visit(product_path(p1))
    click_button("カートに入れる")
    expect(page).to have_current_path(cart_path)
    expect(page).to have_content("商品をカートに追加しました。")
    expect(page).to have_content(p1.name)
  end
end
