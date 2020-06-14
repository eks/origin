require 'rails_helper'

RSpec.describe RiskEvaluationsController, type: :controller do
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  def json
    JSON.parse(response.body)
  end

  describe "POST risk_evaluations" do
    context 'when not authorized' do
      subject { post :create }

      it 'return 401 status code' do
        subject

        expect(response).to have_http_status(:unauthorized)
        expect(json['error']).to include('Not Authorized')
      end
    end

    context 'when valid parameters are provided' do
      let!(:user) { create :user }
      before { request.headers['authorization'] = token_generator(user.id) }

      let(:valid_attributes) do
        {
          "age": 35,
          "dependents": 2,
          "house": {
            "ownership_status": "owned"
          },
          "income": 0,
          "marital_status": "single",
          "risk_questions": [0, 1, 0],
          "vehicle": {
            "year": 2018
          }
        }
      end
      subject { post :create, params: valid_attributes }

      it 'should have a valid JSON schema' do
        subject

        expect(response).to_not be_nil
        expect(response).to match_response_schema("risk_profile")
      end
    end

    context 'when clients are ineligible' do
      let!(:user) { create :user }
      before { request.headers['authorization'] = token_generator(user.id) }

      let(:valid_attributes) do
        {
          "age": 35,
          "dependents": 2,
          "house": {
            "ownership_status": "owned"
          },
          "income": 0,
          "marital_status": "single",
          "risk_questions": [0, 1, 0],
          "vehicle": {
            "year": 2018
          }
        }
      end
      subject { post :create, params: valid_attributes }

      it 'for life and disability insurance' do
        valid_attributes[:age] = 65
        valid_attributes[:income] = 200_001
        subject
        expect(response).to have_http_status(:created)
        expect(json).to include("life" => "ineligible", "disability" => "ineligible")
      end

      it 'for disability insurance by having no income' do
        valid_attributes[:income] = 0
        subject
        expect(json).to include("disability" => "ineligible")
      end

      it 'for home insurance by having no home' do
        valid_attributes[:house] = {}
        subject
        expect(json).to include("home" => "ineligible")
      end

      it 'for home insurance by having no home key' do
        valid_attributes.delete(:house)
        subject
        expect(json).to include("home" => "ineligible")
      end

      it 'for auto insurance by having no vehicle' do
        valid_attributes[:vehicle] = {}
        subject
        expect(json).to include("auto" => "ineligible")
      end

      it 'for auto insurance by having no vehicle key' do
        valid_attributes.delete(:vehicle)
        subject
        expect(json).to include("auto" => "ineligible")
      end
    end

    context "when client's profile" do
      let!(:user) { create :user }
      before { request.headers['authorization'] = token_generator(user.id) }

      let(:valid_attributes) do
        {
          "age": 35,
          "dependents": 2,
          "house": {
            "ownership_status": "owned"
          },
          "income": 2_000_000,
          "marital_status": "single",
          "risk_questions": [0, 0, 0],
          "vehicle": {
            "year": 2018
          }
        }
      end
      subject { post :create, params: valid_attributes }

      it 'is economic' do
        subject
        expect(json).to include(
          "auto"       => "economic",
          "disability" => "economic",
          "home"       => "economic",
          "life"       => "economic"
        )
      end

      it 'is regular' do
        valid_attributes[:risk_questions] = [1,1,1]
        subject
        expect(json).to include(
          "auto"       => "regular",
          "disability" => "regular",
          "home"       => "regular",
          "life"       => "regular"
        )
      end

      it 'is responsible' do
        valid_attributes[:age] = 50
        valid_attributes[:risk_questions] = [1,1,1]
        valid_attributes[:house][:ownership_status] = 'mortgaged'
        subject
        expect(json).to include(
          "auto"       => "responsible",
          "disability" => "responsible",
          "home"       => "responsible",
          "life"       => "responsible"
        )
      end

      it 'is married' do
        valid_attributes[:age] = 50
        valid_attributes[:risk_questions] = [1,0,1]
        valid_attributes[:income] = 200
        valid_attributes[:marital_status] = 'married'
        valid_attributes[:dependents] = 0
        valid_attributes.delete(:house)
        valid_attributes.delete(:vehicle)
        subject
        expect(json).to include(
          "auto"       => "ineligible",
          "disability" => "regular",
          "home"       => "ineligible",
          "life"       => "responsible"
        )
      end

      it 'is young' do
        valid_attributes[:age] = 25
        valid_attributes[:risk_questions] = [1,0,1]
        valid_attributes[:income] = 200
        valid_attributes[:marital_status] = 'single'
        valid_attributes[:dependents] = 0
        valid_attributes.delete(:house)
        valid_attributes.delete(:vehicle)
        subject
        expect(json).to include(
          "auto"       => "ineligible",
          "disability" => "economic",
          "home"       => "ineligible",
          "life"       => "economic"
        )
      end

      it 'is middle age' do
        valid_attributes[:age] = 50
        valid_attributes[:risk_questions] = [1,0,1]
        valid_attributes.delete(:house)
        valid_attributes.delete(:vehicle)
        subject
        expect(json).to include(
          "auto"       => "ineligible",
          "disability" => "regular",
          "home"       => "ineligible",
          "life"       => "regular"
        )
      end
    end
  end
end
