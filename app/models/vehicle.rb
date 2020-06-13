class Vehicle < ApplicationRecord
  belongs_to :user

  validates :year, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
