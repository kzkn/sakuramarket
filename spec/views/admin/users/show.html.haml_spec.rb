require 'rails_helper'

RSpec.describe "admin/users/show", type: :view do
  before(:each) do
    @admin_user = assign(:admin_user, Admin::User.create!(
      :email => "Email",
      :ship_name => "Ship Name",
      :ship_address => "Ship Address"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Ship Name/)
    expect(rendered).to match(/Ship Address/)
  end
end
