FactoryBot.define do
  factory :user do
    name { "Bruce Wayne" }
    email { "email@example.com" }
    password_digest { "this_is_secret" }
  end
end
