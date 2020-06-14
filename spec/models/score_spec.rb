require 'rails_helper'

RSpec.describe Score, type: :model do
  describe '#validations' do

  end

  describe '#association' do
    it { should belong_to(:risk_profile) }
  end
end
