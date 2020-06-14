class Score < ApplicationRecord
  belongs_to :risk_profile

  validates :life, :home, :auto, :disability, presence: true
  validates :life, :home, :auto, :disability, numericality: { only_integer: true }
end
