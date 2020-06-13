require 'rails_helper'

RSpec.describe House, type: :model do
  describe '#validations' do
    it 'have valid factory' do
      house = build :house

      expect(house).to be_valid
    end

    it 'validates presence of ownership status' do
      house = build :house, ownership_status: nil

      expect(house).to be_invalid
      expect(house.errors.messages[:ownership_status]).to include("can't be blank")
    end

    it 'validates ownership_status is included within owned or mortgaged' do
      invalid = 'invalid'
      house = build(:house, ownership_status: invalid)
      expect(house).to be_invalid
      expect(house.errors.messages[:ownership_status]).to include("#{invalid} is not a valid ownership status")
    end
  end

  describe '#associations' do
    it { should belong_to(:user) }
  end
end
