FactoryBot.define do
  factory :stash_yarn do
    user
  end

  trait :with_yarn_product do
    yarn_product
  end

  trait :with_colorway do
    colorway
  end
end
