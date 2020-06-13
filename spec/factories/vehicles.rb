FactoryBot.define do
  factory :vehicle do
    year { 1 }
    # user { nil }
    association(:user)
  end
end
