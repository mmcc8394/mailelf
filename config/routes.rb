Rails.application.routes.draw do
  get 'home/show'

  resource :login, except: [ :index ] do
    collection do
      get 'lost_password_email'
      post 'request_password_reset'
    end
  end

  resources :users do
    member do
      get 'edit_password'
      put 'update_password'
    end
  end

  resources :email_templates
  resources :campaigns

  root 'logins#new'
end
