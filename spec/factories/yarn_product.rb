FactoryBot.define do
  factory :yarn_product do
    name { SecureRandom.hex(6) }
  end
end
