Rails.application.routes.draw do
  devise_for :users
  resources :questions, only: %i[index show new create] do
    resources :answers, only: %i[index show new create]
  end
  root to: "quesions#index"
end
