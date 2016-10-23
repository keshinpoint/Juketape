Rails.application.routes.draw do

  get '/sign_in' => 'sessions#new', as: 'sign_in'
  delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'

  constraints Clearance::Constraints::SignedOut.new do
    root to: 'sessions#new'
  end

  constraints Clearance::Constraints::SignedIn.new do
    root to: 'artists#dashfolio'
  end

  resources :users,
    controller: 'clearance/users',
    only: Clearance.configuration.user_actions do
    end

  resources :users, only: [:update]
  resources :passwords, only: [:new, :create, :edit, :update]

  resource :session, only: [:new, :create]
  resources :registrations, only: [:create]
  resources :artists, only: [] do
    collection do
      get :dashfolio
      get :fetch_content
      put :filter_content
      get :search
      delete :disconnect_network
    end
    resources :tags, only: [:create, :destroy]
  end
  get 'dashfolio/:username' => 'artists#dashfolio', as: :artist_dashfolio
  get 'connections/:username' => 'artists#connections', as: :artist_connections
  resources :timeline_events, only: [:create, :update, :destroy] do
    put :update_dates, on: :member
  end
  get '/invite/:username' => 'invitations#invite', as: :invite_artist
  resources :invitations, only: [:new, :create] do
    member do
      put :accept
      put :reject
    end
    collection do
      delete :disconnect
    end
  end
  resources :notifications, only: [:index]
  resources :settings, only: [:index] do
    collection do
      post :act_name
      post :user_location
      post :profile_pic
      post :email
      post :change_password
      put :fb_page
    end
  end
  resources :message_threads, only: [:create, :destroy], param: :slug do
    member do
      post :add_reply
    end
  end
  get 'messages/new/:username' => 'message_threads#new', as: :new_message
  get '/inbox' => 'message_threads#index', as: :artist_inbox
  get '/inbox/:slug' => 'message_threads#show', as: :message_show

  resources :setup, only: [] do
    collection do
      get :name, action: :act_name, as: :act_name
      get :tagline, action: :tag_line
      post :tagline, action: :tag_line
      get :dashfolio_picture, action: :profile_pic
      post :dashfolio_picture, action: :profile_pic
      get :social_accounts, action: :social_media, as: :social_media
      post :social_accounts, action: :social_media
      get :finalize_setup
    end
  end

  controller :setup, path: 'setup' do
    get :authorize_soundcloud
    get :authorize_youtube
    get :authorize_facebook
    get :authorize_instagram
  end

  get '/terms_of_use' => 'static#terms_of_use', as: :terms_of_use_path
  get '/contact_us' => 'static#contact_us', as: :contact_us_path

  scope '/static' do
    resources :welcome do
      collection do
        get :onboarding_one
        get :onboarding_two
        get :onboarding_three
        get :onboarding_four
        get :dashfolio
        get :invite
        get :inbox
        get :notification
        get :new_message
        get :search
        get :settings
        get :forgot_password
        get :new_password
      end
    end
  end
end
