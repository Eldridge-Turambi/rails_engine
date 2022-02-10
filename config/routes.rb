Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "/merchant/:id/items", to: 'merchant_items#index'
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: :merchant_items
      end

      resources :items, only: [:index, :show, :create, :update, :destroy] do
        ## Can this be singular
        resources :merchant, only: [:index], controller: :item_merchant
      end

    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
