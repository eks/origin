FactoryBot.define do
  factory :score do
    life { 0 }
    home { 0 }
    auto { 0 }
    disability { 0 }
    association(:risk_profile)
  end
end
