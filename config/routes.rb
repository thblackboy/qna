Rails.application.routes.draw do
  devise_for :users
  resources :questions, only: %i[index show new create update destroy] do
    resources :answers, only: %i[edit create destroy]
  end
  root to: "questions#index"
end
