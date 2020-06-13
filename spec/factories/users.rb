FactoryBot.define do
  factory :user do
    name { "Bruce Wayne" }
    email { "email@example.com" }
    password { "this_is_secret" }
    age { 35 }
    dependents { 2 }
    income { 0 }
    marital_status { 'married' }
    risk_questions { [0, 1, 0] }
    # association(:house)
  end
end
