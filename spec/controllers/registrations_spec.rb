require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  def json
    JSON.parse(response.body)
  end

  describe '#create' do
    subject { post :create, params: params }

    context 'when invalid data is provided' do
      let(:params) { { email: nil, password: nil } }

      it 'should return unprocessable_entity status code' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should no create a user' do
        expect{ subject }.not_to change(User, :count)
      end

      it 'should return proper json error body' do
        subject
        expect(json).to include(
          "password"=>["can't be blank"],
          "email"=>["can't be blank"]
        )
      end
    end

    context 'when valid data is provided' do
      let(:params) do
        {
          email: 'valid@example.com',
          password: '1234512345',
          password_confirmation: '1234512345'
        }
      end

      it 'should return 201 http status code' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'should create a user' do
        expect(User.exists?(email: 'valid@example.com')).to be_falsey
        expect{ subject }.to change(User, :count).by(1)
        expect(User.exists?(email: 'valid@example.com')).to be_truthy
      end

      it 'should return proper json' do
        subject
        expect(json).to include({
          'email' => 'valid@example.com',
          'age' => 0,
          'dependents' => 0,
          'income' => "0.0",
          'marital_status' => 'single',
          'risk_questions' => [0,0,0]
        })
      end
    end
  end
end
