Rails.application.routes.draw do
  #devise automatic setup on install
  devise_for :users, :controllers => { registrations: 'registrations', confirmations: 'confirmations' }

  devise_scope :user do
    root 'devise/sessions#new'
  end

  namespace 'admin' do
    resources :customers
    resources :services
    resources :site_layouts
    resources :appointments do
      collection do
        get :get_events
        get :appointment_history
        get :listing
      end
      member do
        delete :cancel
        post :move
        post :resize
      end
    end
    resources :availabilities do
      collection do
        get :get_staff
      end
    end

    resources :staffs do
      member do
        put 'deactivate'
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
      end
    end

    resources :availabilities do
      collection do
        get :get_staff
      end
    end
  end

  namespace 'customer' do
    resources :appointments do
      collection do
        get :get_events
        get :get_staff
      end
      member do
        post :move
        post :resize
      end
    end
  end



  get 'welcome', to: 'welcome#index'
  
  get 'new_signee', to:'welcome#new_signee'
  
end
