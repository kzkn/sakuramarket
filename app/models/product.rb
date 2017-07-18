class Product < ApplicationRecord
  acts_as_list

  validates :name, presence: true
  validates :image_filename, presence: true
  validates :price, numericality: { only_integer: true }
  validates :description, presence: true
  validates :hidden, inclusion: { in: [true, false] }

  scope :visible, -> { where(hidden: false) }
end
