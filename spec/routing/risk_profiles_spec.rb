require 'rails_helper'

RSpec.describe RiskProfilesController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(get: "users/1/risk_profiles/1").to route_to("risk_profiles#show", user_id: "1", risk_profile_id: "1")
    end
  end
end
