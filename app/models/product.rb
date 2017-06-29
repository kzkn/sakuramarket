class Product < ApplicationRecord
  acts_as_list

  attr_accessor :image_file

  before_save :read_image

  def read_image
    if self.image_file
      self.image = self.image_file.read
    end
  end
end
