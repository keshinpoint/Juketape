Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  get '/sign_in' => 'sessions#new', as: 'sign_in'
  delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'

  constraints Clearance::Constraints::SignedOut.new do
    root to: 'sessions#new', as: :signed_out_root
  end

  resource :session

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
