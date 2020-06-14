class RiskProfile < ApplicationRecord
  belongs_to :user

  validates :life, :home, :auto, :disability, presence: true
  validates :life, :home, :auto, :disability, inclusion: {
    in: %w(ineligible economic regular responsible),
    message: "%{value} is not a valid option"
  }
end
