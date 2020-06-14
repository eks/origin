FactoryBot.define do
  factory :vehicle do
    year { 1 }
    association(:user)
  end
end
