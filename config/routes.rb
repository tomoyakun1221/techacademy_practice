Rails.application.routes.draw do
  root to: 'static_pages#top'
  
  get 'login', to: 'session#new'
  post 'login', to: 'session#create'
  delete 'logout', to: 'session#destroy'
  
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :users, only: [:index, :new, :create, :edit, :show, :update, :destroy] do
    collection {post :import}
    member do
      patch 'update_index'
      post 'register_start_time'
    end

    collection do
      get 'working_employee_list'
    end
  end
  resources :attendances
end
