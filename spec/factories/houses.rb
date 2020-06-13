FactoryBot.define do
  factory :house do
    ownership_status { "owned" }
    # user { nil }
    association(:user)
  end
end
