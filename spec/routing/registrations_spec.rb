require 'rails_helper'

RSpec.describe RegistrationsController, type: :routing do
  describe "routing" do
    it "routes to #sign_up" do
      expect(post: "/sign_up").to route_to("registrations#create")
    end
  end
end
