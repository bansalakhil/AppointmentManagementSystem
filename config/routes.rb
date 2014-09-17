Rails.application.routes.draw do
  #devise automatic setup on install
  devise_for :users, :controllers => { registrations: 'registrations', confirmations: 'confirmations' }

  devise_scope :user do
    root 'devise/sessions#new'
  end

  namespace 'admin' do
    resources :invitations do
      collection do
        get :accept
      end
    end
    resources :customers do
      member do
        put :enable
      end
    end
    resources :services do
      member do
        put :enable
      end
    end
    resources :site_layouts
    resources :appointments do
      collection do
        get :get_events
        get :listing
      end
      member do
        get :cancel
        get :set_done
      end
    end
    resources :availabilities do
      collection do
        get :get_services
      end
      member do
        put :enable
      end
    end

    resources :staffs do
      member do
        put :enable
      end
    end
  end

  namespace 'staff' do
    resources :appointments do
      collection do
        get :get_events
      end
      member do
        post :move
        post :resize
        get :cancel
      end
    end
  end

  namespace 'customer' do
    resources :appointments do
      collection do
        get :get_events
        get :get_staff
        get :appointment_history
      end
      member do
        get :cancel
        post :move
        post :resize
        get :cancel_list
      end
    end
  end



  get 'welcome', to: 'welcome#index'
  
  get 'new_signee', to:'welcome#new_signee'
  
end
