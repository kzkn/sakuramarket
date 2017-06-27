class DeliveryDestination < ApplicationRecord
  belongs_to :user  # TODO dependent

  validates :name, presence: true
  validates :address, presence: true
end
