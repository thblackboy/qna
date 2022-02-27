Rails.application.routes.draw do
  devise_for :users
  resources :questions, only: %i[index show new create update destroy] do
    member do
      delete :delete_attached_file
    end
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :set_best
        delete :delete_attached_file
      end
    end
  end
  root to: "questions#index"
end
