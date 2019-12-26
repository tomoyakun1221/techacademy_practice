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
      patch 'update_one_month_application'
      patch 'attendances/overtime_application'
      get 'show_only'
      get 'attendances/log'
    end
    collection { post :import }
    collection { get :working_employee_list }
    collection { get :basic_info_edit }
    resources :attendances, only: :update do
    end
  end
    
    resources :attendances, only: :update do
      member do
        patch 'update_overtime_application_notice'
        get 'overtime_application_notice'
        patch 'update_attendance_change_application_notice'
        get 'attendance_change_application_notice'
        get 'one_month_application_notice'
        patch 'update_one_month_application_notice'
      end
    end

  #残業申請のモーダルを表示するためにuser_idとidを持たせた
  get '/users/:user_id/attendances/:id/overtime_application_info', to: 'attendances#overtime_application_info', as: 'overtime_application_info_user_attendance'
end