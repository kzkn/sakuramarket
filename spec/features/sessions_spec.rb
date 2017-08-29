require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  let!(:user) { User.create!(email: "a@a.com", password: "hidebu", password_confirmation: "hidebu") }

  context "not logged in" do
    scenario "successes to login" do
      do_login(user)
      expect(page).to have_content "ログインしました。"
      expect(page).not_to have_link "ログイン"
      expect(page).to have_link "ログアウト"
    end

    scenario "show sign up page" do
      visit login_path
      click_link "新規登録"
      expect(page).to have_current_path signup_path
    end
  end

  context "logged in" do
    before { do_login(user) }

    scenario "successes to logout" do
      click_link "ログアウト"
      expect(page).to have_content "ログアウトしました。"
      expect(page).to have_link "ログイン"
      expect(page).not_to have_link "ログアウト"
    end
  end
end
