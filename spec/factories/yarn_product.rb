FactoryBot.define do
  factory :yarn_product do
    name { SecureRandom.hex(6) }

    trait :with_optional_fields do
      skein_gram_weight { rand 25..250 }
      skein_yards { rand 50..500 }
      fiber_type_name { SecureRandom.hex(6) }
      craft_yarn_council_weight { rand 0..4 }
      description { Faker::Lorem.paragraph }
      referral_link { Faker::Internet.url }
      referral_partner { Faker::Dessert.variety }
      yarn_company_name_freetext { SecureRandom.hex(6) }
      weight_id { rand 10..20 }
    end
  end
end
