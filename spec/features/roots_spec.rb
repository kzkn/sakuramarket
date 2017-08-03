require 'rails_helper'

RSpec.feature "Roots", type: :feature do
  it "list all visible products" do
    create(:product)
    create(:product2)

    visit("/")
    expect(page).to have_content("p1")
    expect(page).to have_content("p2")
  end
end
