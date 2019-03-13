Rails.application.routes.draw do
  devise_for :users
  get 'pages/home'
  get 'landing', to: 'pages#landing'
  get 'event', to: 'pages#event'
  get 'promo', to: 'pages#promo'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root page
  root 'pages#home'
  get 'sign-in-development/:id', to: 'pages#sign_in_development', as: :sign_in_development

  get '/set_locale', to: 'application#set_locale'
end
