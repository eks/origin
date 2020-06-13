class User < ApplicationRecord
  has_secure_password
  serialize :risk_questions, Array

  validates :age, :dependents, :income, :marital_status, :risk_questions, presence: true
  validates :age, :dependents, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :income, numericality: { greater_than_or_equal_to: 0 }
  validates :marital_status, inclusion: { in: %w(single married),
    message: "%{value} is not a valid marital status" }
  validates :email, presence: true, uniqueness: true
  validate :risk_answers

  has_one :house

  private

  def risk_answers
    errors.add(:risk_questions, "is not a valid array") if not risk_questions.is_a?(Array)
    errors.add(:risk_questions, "must have 3 booleans") if risk_questions.length != 3
    errors.add(:risk_questions, "values must be 0 or 1") unless risk_questions.each {|i| break unless [0, 1].include?(i)}
  end
end
