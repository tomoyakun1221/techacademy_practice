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
      get 'one_month_application_info'
      patch 'one_month_application'
      patch 'attendances/overtime_application'
    end
    collection { post :import }
    collection { get :working_employee_list }
    collection { get :basic_info_edit }
    resources :attendances, only: :update do
    end
  end
  
  get '/users/:user_id/attendances/:id/overtime_application_info', to: 'attendances#overtime_application_info', as: 'overtime_application_info_user_attendance'
end 