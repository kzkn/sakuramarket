require 'rails_helper'

RSpec.feature "Roots", type: :feature do
  let!(:apple) { create(:product) }
  let!(:melon) { create(:product, name: "melon", image_filename: "melon.jpg") }

  it "list all visible products" do
    visit root_path
    expect(page).to have_content "apple"
    expect(page).to have_content "melon"
  end

  it "shows detail of product" do
    visit root_path
    click_link "apple"
    expect(page).to have_current_path product_path(apple)
  end
end
