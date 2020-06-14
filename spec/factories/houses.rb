FactoryBot.define do
  factory :house do
    ownership_status { "owned" }
    association(:user)
  end
end
