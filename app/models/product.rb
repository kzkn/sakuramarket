class Product < ApplicationRecord
  acts_as_list

  attr_accessor :image_file

  validates :name, presence: true
  validates :image_filename, presence: true, uniqueness: true
  validates :price, numericality: { only_integer: true }
  validates :description, presence: true
  validates :hidden, inclusion: { in: [true, false] }

  scope :visible, -> { where(hidden: false) }
  scope :ordered, -> { order(:position) }

  before_validation :ensure_has_image_filename
  before_save :save_image_file
  after_update :remove_old_image_file

  def image_path(filename = nil)
    "/#{image_relative_path(filename)}"
  end

  def image_filepath(filename = nil)
    Rails.root.join("public", image_relative_path(filename))
  end

  def image_relative_path(filename = nil)
    "upload/product/#{filename || image_filename}"
  end

  private
  def ensure_has_image_filename
    self.image_filename = generate_image_filename if image_file
  end

  def generate_image_filename
    random = SecureRandom.hex(16)
    ext = File.extname(image_file.original_filename)
    "#{random}#{ext}"
  end

  def save_image_file
    if image_file
      path = image_filepath
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, "w+b") do |f|
        f.write(image_file.read)
      end
    end
  end

  def remove_old_image_file
    if image_filename_change
      path = image_filepath(image_filename_before_last_save)
      safe_delete(path)
    end
  end

  def remove_image_file
    safe_delete(image_filepath)
  end

  def safe_delete(path)
    File.delete(path) if File.exists?(path)
  end
end
