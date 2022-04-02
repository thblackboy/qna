Rails.application.routes.draw do
  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  devise_for :users
  resources :achieves, only: :index
  resources :votes, only:  :destroy
  resources :attachments, only: :destroy
  resources :questions, only: %i[index show new create update destroy], concerns: [:votable], defaults: { votable: 'questions' } do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: [:votable], defaults: { votable: 'answers' } do
      member do
        patch :set_best
      end
    end
  end
  root to: "questions#index"
end
