FactoryBot.define do
  factory :risk_profile do
    life       { "ineligible" }
    home       { "ineligible" }
    auto       { "ineligible" }
    disability { "ineligible" }
    association(:user)
  end
end
