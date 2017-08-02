FactoryGirl.define do
  factory :product do
    name "p1"
    image_filename "img"
    price 100
    description "p1"
    hidden false
  end

  factory :product2, class: Product do
    name "p2"
    image_filename "img2"
    price 100
    description "p2"
    hidden false
  end
end
