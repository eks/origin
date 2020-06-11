class RiskEvaluationsController < ApplicationController

  def create
    render json: risk_profile(params).to_json, status: :created
  end

  private

  def risk_profile(params)
    return ScoreCalculator.new(params).calculate
  end
end
