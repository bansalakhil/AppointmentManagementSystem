Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'registrations' }
  mount FullcalendarEngine::Engine => "/fullcalendar_engine"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  resources :staffs do
    member do
      put 'deactivate'
    end
  end
  resources :appointments
  resources :customers do
    collection do
      get 'search'
    end
  end

  resources :services do
    # get 'services/new', to: 'services#index'
  end

  resources :availabilities

  resources :site_layouts

  devise_scope :user do
    root 'devise/sessions#new'
  end

  get 'welcome', to: 'welcome#index'
  
  get 'new_signee', to:'welcome#new_signee'
  
end
