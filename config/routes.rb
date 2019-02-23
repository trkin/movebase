Rails.application.routes.draw do
  devise_for :users
  get 'pages/home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root page
  root 'pages#home'
  get '/set_locale', to: 'application#set_locale'
end
