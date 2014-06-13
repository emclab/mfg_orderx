MfgOrderx::Engine.routes.draw do
  resources :orders do
    collection do
      get :search
      get :search_results
      get :stats
      get :stats_results
    end
  end

  root :to => 'orders#index'
end
