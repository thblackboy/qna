Rails.application.routes.draw do
  devise_for :users
  resources :questions, only: %i[index show new create] do
    resources :answers, only: %i[index show new create destroy]
  end
  root to: "questions#index"
end
