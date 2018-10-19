Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :searchers, only: [:index] do
    collection do
      get 'slack'
      get 'mediawiki'
    end
  end

end
