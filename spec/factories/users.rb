FactoryBot.define do
  factory :user do
    name { "Bruce Wayne" }
    email { "email@example.com" }
    password { "this_is_secret" }
  end
end
