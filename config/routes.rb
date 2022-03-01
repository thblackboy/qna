Rails.application.routes.draw do
  devise_for :users
  resources :attachments, only: :destroy
  resources :questions, only: %i[index show new create update destroy] do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :set_best
      end
    end
  end
  root to: "questions#index"
end
