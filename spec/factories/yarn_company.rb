FactoryBot.define do
  factory :yarn_company do
    name { SecureRandom.hex(6) }

    trait :with_optional_fields do
      website { Faker::Internet.url }
      description { Faker::Lorem.paragraph }
      referral_link { Faker::Internet.url }
      referral_partner { Faker::Dessert.variety }
    end
  end
end
