require 'rails_helper'

RSpec.feature "AdminUsers", type: :feature do
  let!(:admin) { User.create!(email: "a@a.com", password: "hidebu", password_confirmation: "hidebu", admin: true) }
  let!(:user) { create(:user) }

  def do_login
    visit("/login")
    fill_in("メールアドレス", with: "a@a.com")
    fill_in("パスワード", with: "hidebu")
    click_button("ログイン")
  end

  before { do_login }

  it "lists all users" do
    visit("/admin/users")
    expect(page.all("table tr").size).to eq(3)  # 2 users, 1 header
  end

  it "shows user detail" do
    visit(admin_user_path(user))
    expect(page).to have_content(user.email)
    expect(page).to have_content(user.ship_name)
    expect(page).to have_content(user.ship_address)
    expect(page).not_to have_content(user.password_digest)
  end

  it "edits user" do
    visit(edit_admin_user_path(user))
    fill_in("配送先氏名", with: "hogehoge")
    fill_in("配送先住所", with: "fugafuga")
    click_button("保存")

    expect(page).to have_current_path(admin_user_path(user))
    expect(page).to have_content("hogehoge")
    expect(page).to have_content("fugafuga")
  end

  # TODO 削除のテスト
end
