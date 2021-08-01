Rails.application.routes.draw do
  root to: 'static_pages#top'
  
  get 'login', to: 'session#new'
  post 'login', to: 'session#create'
  delete 'logout', to: 'session#destroy'
  
  resources :users, only: [:index, :new, :create, :edit, :show, :update, :destroy]
end
