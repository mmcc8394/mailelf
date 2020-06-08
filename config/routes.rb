Rails.application.routes.draw do
  get 'home/show'

  resource :login, except: [ :index ] do
    collection do
      get 'lost_password_email'
      post 'request_password_reset'
    end
  end
  get 'access-denied', to: 'logins#access_denied', as: 'access_denied'

  resources :users do
    member do
      get 'edit_password'
      put 'update_password'
    end
  end

  resources :email_templates
  resources :campaigns, only: [ :index, :new, :create, :show ]

  get 'unsubscribe/:guid', to: 'contacts#unsubscribe', as: 'unsubscribe'

  root 'logins#new'
end
