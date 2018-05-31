Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions, shallow: true do
    resources :answers do
      member do
        patch :select_best
      end
    end
  end

  resources :attachments, only: :destroy
end
