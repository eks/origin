require 'rails_helper'

RSpec.describe RiskProfile, type: :model do
  describe '#validations' do
    it 'have valid factory' do
      house = build :house

      expect(house).to be_valid
    end

    it 'validates presence of life' do
      profile = build :risk_profile, life: nil

      expect(profile).to be_invalid
      expect(profile.errors.messages[:life]).to include("can't be blank")
    end

    it 'validates life is included within owned or mortgaged' do
      invalid = 'invalid'
      profile = build(:risk_profile, life: invalid)
      expect(profile).to be_invalid
      expect(profile.errors.messages[:life]).to include("#{invalid} is not a valid option")
    end

    it 'validates presence of home' do
      profile = build :risk_profile, home: nil

      expect(profile).to be_invalid
      expect(profile.errors.messages[:home]).to include("can't be blank")
    end

    it 'validates home is included within owned or mortgaged' do
      invalid = 'invalid'
      profile = build(:risk_profile, home: invalid)
      expect(profile).to be_invalid
      expect(profile.errors.messages[:home]).to include("#{invalid} is not a valid option")
    end

    it 'validates presence of auto' do
      profile = build :risk_profile, auto: nil

      expect(profile).to be_invalid
      expect(profile.errors.messages[:auto]).to include("can't be blank")
    end

    it 'validates auto is included within owned or mortgaged' do
      invalid = 'invalid'
      profile = build(:risk_profile, auto: invalid)
      expect(profile).to be_invalid
      expect(profile.errors.messages[:auto]).to include("#{invalid} is not a valid option")
    end

    it 'validates presence of disability' do
      profile = build :risk_profile, disability: nil

      expect(profile).to be_invalid
      expect(profile.errors.messages[:disability]).to include("can't be blank")
    end

    it 'validates disability is included within owned or mortgaged' do
      invalid = 'invalid'
      profile = build(:risk_profile, disability: invalid)
      expect(profile).to be_invalid
      expect(profile.errors.messages[:disability]).to include("#{invalid} is not a valid option")
    end
  end

  describe '#associations' do
    it { should belong_to(:user) }
    it { should have_one(:score) }
  end
end
