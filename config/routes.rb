Rails.application.routes.draw do
  devise_for :users
  resources :achieves, only: :index
  resources :votes, only:  :destroy
  resources :attachments, only: :destroy
  resources :questions, only: %i[index show new create update destroy] do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :set_best
      end
    end
    member do
      post :vote_up
      post :vote_down
    end
  end
  root to: "questions#index"
end
