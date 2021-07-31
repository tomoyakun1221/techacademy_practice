Rails.application.routes.draw do
  root to: 'static_pages#top'

  resources :users, only: [:index, :new, :create, :edit, :show]
end
