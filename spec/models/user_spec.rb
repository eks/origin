require 'rails_helper'

RSpec.describe User, type: :model do
   describe '#validations' do
     it 'should have valid factory' do
       user = create :user
       expect(user).to be_valid
     end

    it 'validates presence of email' do
      user = build(:user, email: nil)

      expect(user).to be_invalid
      expect(user.errors.messages[:email]).to include("can't be blank")
    end

    it 'should validate presence of password for standard provider' do
      user = build :user, name: 'Jason Smith', password: nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:password]).to include("can't be blank")
    end

    it 'should validate uniqueness of email' do
      user = create :user
      second_user = build :user, email: user.email
      expect(second_user).not_to be_valid

      second_user.login = 'new_email@example.com'
      expect(second_user).to be_valid
    end
  end

end
