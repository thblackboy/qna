Rails.application.routes.draw do
  resources :questions, only: %i[index show new create] do
    resources :answers, only: %i[index show new create]
  end
end
