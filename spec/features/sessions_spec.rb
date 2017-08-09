require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  let!(:user) { User.create!(email: "a@a.com", password: "hidebu", password_confirmation: "hidebu") }

  def do_login
    visit("/login")
    fill_in("メールアドレス", with: "a@a.com")
    fill_in("パスワード", with: "hidebu")
    click_button("ログイン")
  end

  context "not logged in" do
    it "successes to login" do
      do_login
      expect(page).to have_content("ログインしました。")
      expect(page).not_to have_link("ログイン")
      expect(page).to have_link("ログアウト")
    end

    it "show sign up page" do
      visit("/login")
      click_link("新規登録")
      expect(page).to have_current_path(signup_path)
    end
  end

  context "logged in" do
    before { do_login }

    it "successes to logout" do
      click_link "ログアウト"
      expect(page).to have_content("ログアウトしました。")
      expect(page).to have_link("ログイン")
      expect(page).not_to have_link("ログアウト")
    end
  end
end
