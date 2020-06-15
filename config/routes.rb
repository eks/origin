Rails.application.routes.draw do
  post 'risk_evaluations', to: 'risk_evaluations#create'
  post 'authenticate', to: 'authentication#authenticate'
  post 'sign_up', to: 'registrations#create'
  get 'users/:user_id/risk_profiles/:risk_profile_id', to: 'risk_profiles#show', as: 'user_risk_profile'
end
