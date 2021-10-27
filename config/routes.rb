Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants/search#show'

      resources :merchants, only: [:show, :index] do
        get '/items', to: 'merchants/items#index'
      end

      get '/items/find_all', to: 'items/search#index'

      resources :items do
        get '/merchant', to: 'items/merchant#show'
      end
    end
  end
end
