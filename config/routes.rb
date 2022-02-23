Rails.application.routes.draw do
  devise_for :users
  resources :questions, only: %i[index show new create update destroy] do
    resources :answers, shallow: true, only: %i[edit create update destroy]
  end
  root to: "questions#index"
end
