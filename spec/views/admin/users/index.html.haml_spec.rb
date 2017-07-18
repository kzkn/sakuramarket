require 'rails_helper'

RSpec.describe "admin/users/index", type: :view do
  before(:each) do
    assign(:admin_users, [
      Admin::User.create!(
        :email => "Email",
        :ship_name => "Ship Name",
        :ship_address => "Ship Address"
      ),
      Admin::User.create!(
        :email => "Email",
        :ship_name => "Ship Name",
        :ship_address => "Ship Address"
      )
    ])
  end

  it "renders a list of admin/users" do
    render
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Ship Name".to_s, :count => 2
    assert_select "tr>td", :text => "Ship Address".to_s, :count => 2
  end
end
