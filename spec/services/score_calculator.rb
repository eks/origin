require 'rails_helper'

RSpec.describe ScoreCalculator do
  describe '#calculate' do
    let(:user) { create :user }
    subject{ ScoreCalculator.new(user).calculate }

    context 'when no home and auto are provided' do
      it 'return proper profile' do
        expect(subject).to include({
          life: 'regular',
          home: 'ineligible',
          auto: 'ineligible',
          disability: 'ineligible'
        })
      end
    end

    context 'when complete user data is provided' do
      let!(:home) { build :house, user: user, ownership_status: 'owned' }
      let!(:auto) { build :vehicle, user: user, year: 2018 }

      it 'return proper profile' do
        expect(subject).to include({
          life: 'regular',
          home: 'economic',
          auto: 'regular',
          disability: 'ineligible'
        })
      end
    end

    context 'when data is persisted' do
      it 'persists risk_profile successfuly' do
        expect{ subject }.to change{ RiskProfile.count }.by(1)
      end

      it 'persists score successfuly' do
        expect{ subject }.to change{ Score.count }.by(1)
      end
    end
  end
end
