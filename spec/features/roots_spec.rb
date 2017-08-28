require 'rails_helper'

RSpec.feature "Roots", type: :feature do
  let!(:p1) { create(:product) }
  let!(:p2) { create(:product, name: "p2", image_filename: "p2") }

  it "list all visible products" do
    visit("/")
    expect(page).to have_content("p1")
    expect(page).to have_content("p2")
  end

  it "shows detail of product" do
    visit("/")
    click_link("p1")
    expect(page).to have_current_path(product_path(p1))
  end
end
