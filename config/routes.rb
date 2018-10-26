Rails.application.routes.draw do
  root to: 'searchers#index'

  resources :searchers, only: [:index, :show]
end
