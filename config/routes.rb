Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :ratingable do
    member do
      post :vote_up
      post :vote_down
      post :vote_reset
    end
  end

  resources :attachments, only: :destroy
  resources :questions, except: [:edit], concerns: [:ratingable] do
    resources :answers, only: [:create, :destroy, :update], shallow: true, concerns: [:ratingable] do
      member do
        patch :select_best
      end
    end
  end
end
