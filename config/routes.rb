require 'sidekiq/web'
Rails.application.routes.draw do
  root 'pages#home'

  devise_for :users, controllers: {
    omniauth_callbacks: 'devise/my_omniauth_callbacks',
    confirmations: 'devise/my_confirmations',
    registrations: 'devise/my_registrations',
  }

  authenticate :user, ->(u) { u.superadmin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get 'pages/home'
  get 'sign-in-development/:id', to: 'pages#sign_in_development', as: :sign_in_development
  get 'set_locale', to: 'application#set_locale'
  get 'contact', to: 'pages#contact'
  post 'contact', to: 'pages#submit_contact'
  get 'sample-error', to: 'pages#sample_error'
  get 'sample-error-in-javascript', to: 'pages#sample_error_in_javascript'
  get 'sample-error-in-javascript-ajax', to: 'pages#sample_error_in_javascript_ajax'
  post 'notify-javascript-error', to: 'pages#notify_javascript_error'
  get 'sample-error-in-sidekiq', to: 'pages#sample_error_in_sidekiq'

  resources :happenings do
    collection do
      post :search
    end
  end

  resource :my_account do
    get :change_email
    get :change_password
    patch :update_password
    get :change_language
    get :edit
    patch :update
  end

  resource :my_clubs do
  end

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :users
    resources :activities
    resources :clubs do
      resources :activity_clubs, shallow: true
    end
    resources :venues
    resources :happenings do
      resources :discipline_happenings, shallow: true
    end
    resources :disciplines do
      resources :discipline_requirements, shallow: true
    end
    resources :requirements
  end
end
