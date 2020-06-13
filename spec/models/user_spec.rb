require 'rails_helper'

RSpec.describe User, type: :model do
   describe '#validations' do
     it 'have valid factory' do
       user = build :user
       expect(user).to be_valid
     end

    it 'validates presence of email' do
      user = build(:user, email: nil)

      expect(user).to be_invalid
      expect(user.errors.messages[:email]).to include("can't be blank")
    end

    it 'validates uniqueness of email' do
      user = create :user
      second_user = build :user, email: user.email
      expect(second_user).not_to be_valid

      second_user.email = 'new_email@example.com'
      expect(second_user).to be_valid
    end

    it 'validates presence of age' do
      user = build(:user, age: nil)
      expect(user).to be_invalid
      expect(user.errors.messages[:age]).to include("can't be blank")
    end

    it 'validates numericality of age' do
      user = build(:user, age: 'NaN')
      expect(user).to be_invalid
      expect(user.errors.messages[:age]).to include("is not a number")
    end

    it 'validates age is positive number' do
      user = build(:user, age: -1)
      expect(user).to be_invalid
      expect(user.errors.messages[:age]).to include("must be greater than or equal to 0")
    end

    it 'validates presence of dependents' do
      user = build(:user, dependents: nil)
      expect(user).to be_invalid
      expect(user.errors.messages[:dependents]).to include("can't be blank")
    end

    it 'validates numericality of dependents' do
      user = build(:user, dependents: 'NaN')
      expect(user).to be_invalid
      expect(user.errors.messages[:dependents]).to include("is not a number")
    end

    it 'validates dependents is positive number' do
      user = build(:user, dependents: -1)
      expect(user).to be_invalid
      expect(user.errors.messages[:dependents]).to include("must be greater than or equal to 0")
    end

    it 'validates presence of income' do
      user = build(:user, income: nil)
      expect(user).to be_invalid
      expect(user.errors.messages[:income]).to include("can't be blank")
    end

    it 'validates numericality of income' do
      user = build(:user, income: 'NaN')
      expect(user).to be_invalid
      expect(user.errors.messages[:income]).to include("is not a number")
    end

    it 'validates income is positive number' do
      user = build(:user, income: -1)
      expect(user).to be_invalid
      expect(user.errors.messages[:income]).to include("must be greater than or equal to 0")
    end

    it 'validates presence of marital_status' do
      user = build(:user, marital_status: nil)
      expect(user).to be_invalid
      expect(user.errors.messages[:marital_status]).to include("can't be blank")
    end

    it 'validates marital_status is included within single or married' do
      invalid = 'invalid'
      user = build(:user, marital_status: invalid)
      expect(user).to be_invalid
      expect(user.errors.messages[:marital_status]).to include("#{invalid} is not a valid marital status")
    end

    it 'validates presence of risk_questions' do
      user = build(:user, risk_questions: nil)
      expect(user).to be_invalid
      expect(user.errors.messages[:risk_questions]).to include("can't be blank")
    end

    it 'validates risk_questions elements as boolean' do
      user = build(:user, risk_questions: [2, 3, 4])
      expect(user).to be_invalid
      expect(user.errors.messages[:risk_questions]).to include("values must be 0 or 1")
    end

    it 'validates risk_questions length' do
      user = build(:user, risk_questions: [0, 0])
      expect(user).to be_invalid
      expect(user.errors.messages[:risk_questions]).to include("must have 3 booleans")
    end
  end
end
