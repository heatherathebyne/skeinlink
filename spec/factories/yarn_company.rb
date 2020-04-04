FactoryBot.define do
  factory :yarn_company do
    name { SecureRandom.hex(6) }
  end
end
