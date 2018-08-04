Rails.application.routes.draw do
  get 'hello_world', to: 'hello_world#index'
  use_doorkeeper
  root to: 'questions#index'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resources :users, only: [] do
    member do
      get :add_email
      patch :signup_email
    end
  end

  concern :ratingable do
    member do
      post :vote_up
      post :vote_down
      post :vote_reset
    end
  end

  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  resources :search, only: :index

  resources :attachments, only: :destroy
  resources :questions, except: [:edit], concerns: [:ratingable, :commentable] do
    resources :answers, only: [:create, :destroy, :update], shallow: true, concerns: [:ratingable, :commentable] do
      member do
        patch :select_best
      end
    end
    resources :subscriptions, only: [:create, :destroy], shallow: true
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create], shallow: true
      end
    end
  end
end
