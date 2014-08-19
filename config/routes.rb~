Mathalarm::Application.routes.draw do
  
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :alarms, only: [:index, :show] do
        resources :samples, except: [:new, :edit]
      end
    end
  end

  resources :home, only: [:index]
  resources :plans, only: [:index]
  
  match "/alarms/:id/export(/:notification_id)", as: "export_alarm", to: "alarms#export", via: [:get] 
  
  resources :alarms do
    resources :samples, except: [:show]
    resources :receivers, except: [:show]
    resources :notifications, only: [:index, :show]
    resources :imports, only: [:new, :create]    
  end
  
  root :to => 'home#index'

end
