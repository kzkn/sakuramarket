require 'rails_helper'

RSpec.feature "Admins", type: :feature do
  let!(:normal) { User.create!(email: "a@a.com", password: "hidebu", password_confirmation: "hidebu", admin: false) }
  let!(:admin) { User.create!(email: "b@b.com", password: "hidebu", password_confirmation: "hidebu", admin: true) }

  def do_login(user)
    visit("/login")
    fill_in("メールアドレス", with: user.email)
    fill_in("パスワード", with: user.password)
    click_button("ログイン")
  end

  it "shows admin link" do
    do_login(admin)
    visit("/")
    click_link("管理")
    expect(page).to have_current_path(admin_path)
  end

  it "hides admin link" do
    do_login(normal)
    visit("/")
    expect(page).not_to have_link("管理")
  end
end
