require 'rails_helper'

RSpec.describe "admin/products/index", type: :view do
  before(:each) do
    assign(:admin_products, [
      Admin::Product.create!(
        :name => "Name",
        :image_filename => "Image Filename",
        :price => 2,
        :description => "MyText",
        :hidden => false
      ),
      Admin::Product.create!(
        :name => "Name",
        :image_filename => "Image Filename",
        :price => 2,
        :description => "MyText",
        :hidden => false
      )
    ])
  end

  it "renders a list of admin/products" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Image Filename".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
