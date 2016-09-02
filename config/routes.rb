Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'welcome#index'

  resources :welcome do
    collection do
      get :setup_one
      get :setup_two
      get :onboarding_one
      get :onboarding_two
      get :onboarding_three
    end
  end
end
