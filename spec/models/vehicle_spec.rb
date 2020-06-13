require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe '#validations' do
    it 'have valid factory' do
      vehicle = build :vehicle

      expect(vehicle).to be_valid
    end

    it 'validates presence of year' do
      vehicle = build :vehicle, year: nil

      expect(vehicle).to be_invalid
      expect(vehicle.errors.messages[:year]).to include("can't be blank")
    end

    it 'validates numericality of year' do
      vehicle = build(:vehicle, year: 'NaN')
      expect(vehicle).to be_invalid
      expect(vehicle.errors.messages[:year]).to include("is not a number")
    end

    it 'validates year is positive number' do
      vehicle = build(:vehicle, year: -1)
      expect(vehicle).to be_invalid
      expect(vehicle.errors.messages[:year]).to include("must be greater than or equal to 0")
    end
  end

  describe '#associations' do
    it { should belong_to(:user) }
  end
end
