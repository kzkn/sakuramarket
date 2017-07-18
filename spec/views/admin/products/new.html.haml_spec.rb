require 'rails_helper'

RSpec.describe "admin/products/new", type: :view do
  before(:each) do
    assign(:admin_product, Admin::Product.new(
      :name => "MyString",
      :image_filename => "MyString",
      :price => 1,
      :description => "MyText",
      :hidden => false
    ))
  end

  it "renders new admin_product form" do
    render

    assert_select "form[action=?][method=?]", admin_products_path, "post" do

      assert_select "input[name=?]", "admin_product[name]"

      assert_select "input[name=?]", "admin_product[image_filename]"

      assert_select "input[name=?]", "admin_product[price]"

      assert_select "textarea[name=?]", "admin_product[description]"

      assert_select "input[name=?]", "admin_product[hidden]"
    end
  end
end
