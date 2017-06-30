class Product < ApplicationRecord
  default_scope ->{ order(:position) }

  acts_as_list
  scope :for_display, ->{
    select(:id, :name).where(hidden: false)
  }
  scope :visible, ->{ where(hidden: false) }

  attr_accessor :image_file

  before_save :read_image

  def read_image
    if self.image_file
      self.image = self.image_file.read
    end
  end
end
