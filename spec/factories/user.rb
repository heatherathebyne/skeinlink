FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'yarnaddict1' }
    confirmed_at { Time.current }
  end

  trait :superadmin do
    role_superadmin { true }
  end

  trait :admin do
    role_admin { true }
  end

  trait :maintainer do
    role_maintainer { true }
  end

  trait :moderator do
    role_moderator { true }
  end

  trait :crafter do
    name { 'Test Crafter' }
    about_me { 'Testing all the things' }
  end
end
