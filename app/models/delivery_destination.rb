class DeliveryDestination < ApplicationRecord
  belongs_to :user, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true
end
