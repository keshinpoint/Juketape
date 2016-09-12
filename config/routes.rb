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
  end
  resources :timeline_events, only: [:create, :update]

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
      end
    end
  end
end
