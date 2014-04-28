MfgOrderx::Engine.routes.draw do
  resources :orders do
    collection do
      get :search
      put :search_results
      get :stats
      put :stats_results
    end
  end

  root :to => 'orders#index'
end
