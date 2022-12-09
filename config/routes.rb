Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  
  namespace :api do
    namespace :v1 do
      get '/items/:id/merchant', to: 'item_merchant#show'
      get '/merchants/find_all', to: 'merchant_search#index'
      get '/items/find', to: 'item_search#show'
      
      resources :merchants, only: %i[index show] do
        scope module: 'merchants' do
          resources :items, only: [:index]
        end
      end

      resources :items, only: %i[index show create destroy update]
    end
  end
end
