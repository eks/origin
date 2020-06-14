require 'rails_helper'

RSpec.describe Score, type: :model do
  describe '#validations' do
    it 'have valid factory' do
      score = build(:score)

      expect(score).to be_valid
    end

    it 'validates presence of life' do
      score = build(:score, life: nil)

      expect(score).to be_invalid
      expect(score.errors.messages[:life]).to include("can't be blank")
    end

    it 'validates numericality of life' do
      score = build(:score, life: 'NaN')
      expect(score).to be_invalid
      expect(score.errors.messages[:life]).to include("is not a number")
    end

    it 'validates presence of home' do
      score = build(:score, home: nil)

      expect(score).to be_invalid
      expect(score.errors.messages[:home]).to include("can't be blank")
    end

    it 'validates numericality of home' do
      score = build(:score, home: 'NaN')
      expect(score).to be_invalid
      expect(score.errors.messages[:home]).to include("is not a number")
    end

    it 'validates presence of auto' do
      score = build(:score, auto: nil)

      expect(score).to be_invalid
      expect(score.errors.messages[:auto]).to include("can't be blank")
    end

    it 'validates numericality of auto' do
      score = build(:score, auto: 'NaN')
      expect(score).to be_invalid
      expect(score.errors.messages[:auto]).to include("is not a number")
    end

    it 'validates presence of disability' do
      score = build(:score, disability: nil)

      expect(score).to be_invalid
      expect(score.errors.messages[:disability]).to include("can't be blank")
    end

    it 'validates numericality of disability' do
      score = build(:score, disability: 'NaN')
      expect(score).to be_invalid
      expect(score.errors.messages[:disability]).to include("is not a number")
    end
  end

  describe '#association' do
    it { should belong_to(:risk_profile) }
  end
end
