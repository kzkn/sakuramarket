require 'rails_helper'

RSpec.feature "Admins", type: :feature do
  let!(:normal) { User.create!(email: "a@a.com", password: "hidebu", password_confirmation: "hidebu", admin: false) }
  let!(:admin) { User.create!(email: "b@b.com", password: "hidebu", password_confirmation: "hidebu", admin: true) }

  scenario "shows admin link" do
    do_login(admin)
    visit root_path
    click_link "管理"
    expect(page).to have_current_path admin_root_path
  end

  scenario "hides admin link" do
    do_login(normal)
    visit root_path
    expect(page).not_to have_link "管理"
  end
end
