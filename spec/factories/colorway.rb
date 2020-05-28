FactoryBot.define do
  factory :colorway do
    name { SecureRandom.hex(6) }
    yarn_product

    trait :with_optional_fields do
      number { SecureRandom.hex(3) }
    end
  end
end
