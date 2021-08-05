Rails.application.routes.draw do
  root to: 'static_pages#top'
  
  get 'login', to: 'session#new'
  post 'login', to: 'session#create'
  delete 'logout', to: 'session#destroy'
  get 'working_employee_list', to: 'users#working_employee_list'
  
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :users, only: [:index, :new, :create, :edit, :show, :update, :destroy] do
    member do
      patch 'update_index'
    end
  end
end
