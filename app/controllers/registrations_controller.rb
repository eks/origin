class RegistrationsController < ApplicationController
  skip_before_action :authenticate_request, only: :create

  def create
    user = User.new(registration_params)
    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params[:user] = params
    params.require(:user).permit(:email, :password)
  end
end
