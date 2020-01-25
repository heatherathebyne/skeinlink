FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'yarnaddict1' }
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
end
