Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :ratingable do
    member do
      post :vote_up
      post :vote_down
      post :vote_reset
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions, shallow: true, concerns: [:ratingable] do
    resources :answers, concerns: [:ratingable] do
      member do
        patch :select_best
      end
    end
  end

  resources :attachments, only: :destroy
end
