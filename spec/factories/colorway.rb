FactoryBot.define do
  factory :colorway do
    name { SecureRandom.hex(6) }
    yarn_product
  end
end
