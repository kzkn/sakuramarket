FactoryGirl.define do
  factory :product do
    name "apple"
    image_filename "apple.jpg"
    price 100
    description "Fresh Apple!"
    hidden false
  end
end
