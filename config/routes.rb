Rails.application.routes.draw do
  get 'users/new'

  root to: 'static_pages#top'

  get 'signup', to: 'users#new'
  resources :users
end