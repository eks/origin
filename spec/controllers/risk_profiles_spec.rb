require 'rails_helper'

RSpec.describe RiskProfilesController, type: :controller do
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  def json
    JSON.parse(response.body)
  end

  describe '#show' do
    let!(:user) { create :user }
    let!(:risk_profile) { create :risk_profile, user: user }
    subject { get :show, params: {user_id: user.id, risk_profile_id: risk_profile.id} }
    before { request.headers['authorization'] = token_generator(user.id) }

    context 'when wrong risk profile id is provided' do
      it 'return 404 status code' do
        risk_profile.id = 100_000
        subject
        expect(response).to have_http_status(:not_found)
      end

      it 'return proper json error' do
        risk_profile.id = 100_000
        subject
        expect(json['error']).to include("Couldn't find RiskProfile with 'id'=#{risk_profile.id}")
      end
    end

    context 'when wrong user id is provided' do
      let(:second_user) { create :user }
      subject { get :show, params: {user_id: second_user.id, risk_profile_id: risk_profile.id} }

      it 'return 403 status code' do
        subject
        expect(response).to have_http_status(:forbidden)
      end

      it 'return proper json error' do
        user.id = 100_000
        subject
        expect(json['error']).to include('Forbidden')
      end
    end

    context 'when right data is provided' do
      it 'return success response' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'have proper json body' do
        subject
        expect(json).to include({
          'life' => risk_profile.life,
          'home' => risk_profile.home,
          'auto' => risk_profile.auto,
          'disability' => risk_profile.disability
        })
      end
    end
  end
end
