Rails.application.routes.draw do
  mount FullcalendarEngine::Engine => "/fullcalendar_engine"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  resources :staffs
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

end
