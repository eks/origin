require 'rails_helper'

RSpec.describe RiskEvaluationsController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/risk_evaluations").to route_to("risk_evaluations#create")
    end
  end
end
