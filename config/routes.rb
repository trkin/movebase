require 'sidekiq/web'
Rails.application.routes.draw do
  shallow do
    devise_for :users, only: :omniauth_callbacks, controllers: {
      omniauth_callbacks: 'devise/my_omniauth_callbacks',
    }
    scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
      root 'pages#home'

      devise_for :users, skip: :omniauth_callbacks, controllers: {
        registrations: 'devise/my_registrations',
      }

      authenticate :user, ->(u) { u.superadmin? } do
        mount Sidekiq::Web => '/sidekiq'
      end

      get 'pages/home'
      get 'sign-in-development/:id', to: 'pages#sign_in_development', as: :sign_in_development
      get 'sample-error', to: 'pages#sample_error'
      get 'sample-error-in-javascript', to: 'pages#sample_error_in_javascript'
      get 'sample-error-in-javascript-ajax', to: 'pages#sample_error_in_javascript_ajax'
      post 'notify-javascript-error', to: 'pages#notify_javascript_error'
      get 'sample-error-in-sidekiq', to: 'pages#sample_error_in_sidekiq'
      get '/test', to: 'pages#test'
      get '/cookies', to: 'pages#cookies'
      get '/terms', to: 'pages#terms'
      get '/about', to: 'pages#about'

      resource :contact

      resources :links do
        collection do
          post :search
        end
      end
      resources :happenings do
        collection do
          post :search
          get :index_for_activities
          post :search_for_activities
          get :index_for_disciplines
          post :search_for_disciplines
        end
        resources :links
      end

      resource :my_account do
        get :change_email
        get :change_password
        patch :update_password
        get :change_language
        get :edit
        patch :update
      end

      resources :clubs do
        resources :links
        collection do
          post :search
        end
        member do
          post :search_happenings
        end
      end
      resources :venues

      resource :my_club do
        patch :submit_choose
        delete :remove_me_from
      end
      resources :club_users do
        collection do
          post :search
        end
      end

      resources :translations do
        collection do
          post :search
        end
      end

      resources :activities do
        collection do
          post :search
        end
      end

      namespace :admin do
        get 'dashboard', to: 'dashboard#index'
        resources :users do
          collection do
            post :search
          end
          resources :user_roles
        end
        resources :clubs do
          resources :activity_clubs
          collection do
            post :search
          end
          member do
            post :search_happenings
          end
          resources :happenings, only: %i[new create]
        end
        resources :venues
        resources :happenings, except: %i[new create] do
          member do
            get :edit_recurrence
            patch :update_recurrence
          end
          collection do
            get :parse_url
          end
          resources :discipline_happenings
        end
        resources :disciplines do
          resources :discipline_requirements
          resources :discipline_associations
        end
        resources :requirements
      end
    end
  end
end
