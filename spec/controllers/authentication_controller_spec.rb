require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  def json
    JSON.parse(response.body)
  end

  describe '#authenticate' do
    context 'when invalid credential are used' do
      let!(:user) { build :user }
      before { request.headers['authorization'] = token_generator(user.id) }
      subject { post :authenticate, params: { email: 'invalid@exmaple.com', password: 'invalid' } }

      it 'return invalid crdentials' do
        subject
        expect(json['error']).to include('user_authentication' => 'invalid credentials')
      end

      it 'return 401 status code' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when valid credentails are used' do
      let!(:user) { create :user }
      before { request.headers['authorization'] = token_generator(user.id) }

      it 'return 201 status code' do
        post :authenticate, params: { email: user.email, password: user.password }
        expect(response).to have_http_status(:created)
      end
    end

  end
end
