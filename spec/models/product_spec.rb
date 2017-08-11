require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "image_file" do
    let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test.jpg")) }
    let!(:product) { build(:product) }

    it "copies to under the public/upload/product" do
      product.image_file = file
      product.save!

      expect(product.image_path).to eq("/upload/product/#{product.image_filename}")
      expect(File.exist?(product.image_filepath)).to be_truthy
    end

    it "deletes obsoleted image files when update image_file" do
      product.image_file = file
      product.save!
      path1 = product.image_filepath

      product.image_file = file
      product.save!
      path2 = product.image_filepath

      expect(path1).not_to eq(path2)
      expect(File.exist?(path1)).to be_falsey
      expect(File.exist?(path2)).to be_truthy
    end

    it "deletes image file when destroy product" do
      product.image_file = file
      product.save!
      path = product.image_filepath
      product.destroy!

      expect(File.exist?(path)).to be_falsey
    end
  end

  describe "validation" do
    let!(:product) { build(:product) }

    it "valid" do
      expect(product).to be_valid
    end

    %w(name image_filename price description hidden).each do |field|
      it "invalid when #{field} is blank" do
        product.send("#{field}=", nil)
        expect(product).not_to be_valid
      end
    end

    it "invalid when image_filename is not unique" do
      Product.create(name: "a", image_filename: product.image_filename,
        price: 1, description: "b", hidden: false)
      expect(product).not_to be_valid
    end

    it "invalid when price is not a number" do
      product.price = "a"
      expect(product).not_to be_valid
    end

    it "invalid when price is not a integer" do
      product.price = 1.1
      expect(product).not_to be_valid
    end
  end
end
