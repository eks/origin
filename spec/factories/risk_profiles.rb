FactoryBot.define do
  factory :risk_profile do
    life       { "ineligible" }
    home       { "economic" }
    auto       { "regular" }
    disability { "responsible" }
    association(:user)
  end
end
