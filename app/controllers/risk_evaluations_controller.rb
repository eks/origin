# frozen_string_literal: true

class RiskEvaluationsController < ApplicationController
  before_action :create_or_update_house, :create_or_update_vehicle, only: [:create]

  def create
    if current_user.update(user_params)
      render json: risk_profile.to_json,
             status: :created,
             location: user_risk_profile_path(current_user, current_user.risk_profiles.last)
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params[:user] = params
    params[:user][:risk_questions] = params[:risk_questions].map(&:to_i) unless params[:risk_questions].empty?
    params.fetch(:user, {}).permit(
      :user, :age, :dependents, :marital_status, :income, :house, :vehicle, { risk_questions: [] }
    )
  end

  def create_or_update_house
    return current_user.build_house(house_params) if params[:house] && current_user.house.nil?

    current_user.house.update(ownership_status: params[:house][:ownership_status]) if params[:house]
  end

  def create_or_update_vehicle
    return current_user.build_vehicle(vehicle_params) if params[:vehicle] && current_user.vehicle.nil?

    current_user.vehicle.update(year: params[:vehicle][:year]) if params[:vehicle]
  end

  def house_params
    params.require(:house).permit(:ownership_status)
  end

  def vehicle_params
    params.require(:vehicle).permit(:year)
  end

  def risk_profile
    ScoreCalculator.new(current_user).calculate
  end
end
