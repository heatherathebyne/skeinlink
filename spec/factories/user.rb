FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'yarnaddict1' }
  end
end
