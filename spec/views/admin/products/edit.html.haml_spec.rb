require 'rails_helper'

RSpec.describe "admin/products/edit", type: :view do
  before(:each) do
    @admin_product = assign(:admin_product, Admin::Product.create!(
      :name => "MyString",
      :image_filename => "MyString",
      :price => 1,
      :description => "MyText",
      :hidden => false
    ))
  end

  it "renders the edit admin_product form" do
    render

    assert_select "form[action=?][method=?]", admin_product_path(@admin_product), "post" do

      assert_select "input[name=?]", "admin_product[name]"

      assert_select "input[name=?]", "admin_product[image_filename]"

      assert_select "input[name=?]", "admin_product[price]"

      assert_select "textarea[name=?]", "admin_product[description]"

      assert_select "input[name=?]", "admin_product[hidden]"
    end
  end
end
