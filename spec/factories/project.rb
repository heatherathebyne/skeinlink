FactoryBot.define do
  factory :project do
    craft_id { 1 } # knitting
    user
    name { Faker::Books::CultureSeries.culture_ship }

    trait :public do
      publicly_visible { true }
    end

    trait :private do
      publicly_visible { false }
    end
  end
end
