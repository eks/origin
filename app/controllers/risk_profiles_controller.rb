class RiskProfilesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def show
    profile = current_user.risk_profiles.find(params[:risk_profile_id])

    if current_user.id == params[:user_id].to_i
      render json: profile, status: :ok
    else
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  private

  def not_found
    render json: {
        error: "Couldn't find RiskProfile with 'id'=#{params[:risk_profile_id]}"
      },
      status: :not_found
  end
end
