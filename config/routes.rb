Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  get    '/login', to: 'session#new'
  post   '/login', to: 'session#create'
  delete '/logout', to: 'session#destroy'
  
  resources :points, only: [:new, :index, :create, :destroy] do
    member do
      get 'edit_point_info'
      patch 'update_point_info'
    end
  end

  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end
    collection { post :import }
    collection { get :working_employee_list }
    collection { get :basic_info_edit }
    resources :attendances, only: :update
  end
end