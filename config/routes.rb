Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  get    '/login', to: 'session#new'
  post   '/login', to: 'session#create'
  delete '/logout', to: 'session#destroy'
  
  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
    end
    resources :attendances
  end
end
