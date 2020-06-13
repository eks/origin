class House < ApplicationRecord
  belongs_to :user

  validates :ownership_status, presence: true
  validates :ownership_status, inclusion: { in: %w(owned mortgaged),
    message: "%{value} is not a valid ownership status" }
end
