class RiskEvaluationsController < ApplicationController
  def create
    if current_user.update(user_params)
      render json: risk_profile.to_json, status: :created
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params[:user] = params
    params[:risk_questions] = params[:risk_questions].map(&:to_i) unless params[:risk_questions].empty?
    params[:user][:house_attributes] = params[:house]
    params[:user][:vehicle_attributes] = params[:vehicle]
    params.require(:user).permit(
      :age,
      :dependents,
      :marital_status,
      :income,
      { risk_questions: [] },
      house_attributes: [:id, :ownership_status],
      vehicle_attributes: [:id, :year]
    )
  end

  def risk_profile
    return ScoreCalculator.new(current_user).calculate
  end
end
