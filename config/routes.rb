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
      resource :password,
        controller: 'clearance/passwords',
        only: [:create, :edit, :update]
    end

  resources :users, only: [:update]

  resource :session, only: [:new, :create]
  resources :registrations, only: [:create]
  resources :artists, only: [] do
    get :dashfolio, on: :collection
    get :fetch_content, on: :collection
    put :filter_content, on: :collection
    post :search, on: :collection
    get :search, on: :collection
    resources :tags, only: [:create, :destroy]
  end
  get 'dashfolio/:username' => 'artists#dashfolio', as: :artist_dashfolio
  resources :timeline_events, only: [:create, :update]
  post '/invite' => 'invitations#invite', as: :invite_artist
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
      post :location
      post :profile_pic
      post :email
      post :change_password
    end
  end
  resources :message_threads, only: [:create, :destroy], param: :slug do
    member do
      post :add_reply
    end
  end
  post 'messages/new' => 'message_threads#new', as: :new_message
  get '/inbox' => 'message_threads#index', as: :artist_inbox
  get '/inbox/:slug' => 'message_threads#show', as: :message_show

  resources :setup, only: [], path: :profile do
    collection do
      get :act_name
      get :tag_line
      post :tag_line
      get :profile_pic
      post :profile_pic
      get :social_media
      post :social_media
      get :finalize_setup
    end
  end

  controller :setup, path: 'setup' do
    get :authorize_soundcloud
    get :authorize_youtube
    get :authorize_facebook
    get :authorize_instagram
  end

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
