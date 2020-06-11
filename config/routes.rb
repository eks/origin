Rails.application.routes.draw do
  post 'risk_evaluations', to: 'risk_evaluations#create'
  post 'authenticate', to: 'authentication#authenticate'
end
