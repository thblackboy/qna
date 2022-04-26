require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, except: %i[new edit] do
        resources :answers, shallow: true, except: %i[new edit]
      end
    end
  end

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  concern :commentable do
    member do
      post :add_comment
    end
  end

  devise_for :users
  resources :achieves, only: :index
  resources :votes, only:  :destroy
  resources :attachments, only: :destroy
  resources :questions, only: %i[index show new create update destroy], concerns: %i[votable commentable],
                        defaults: { votable: 'questions' } do
    post :subscribe, on: :member
    delete :unsubscribe, on: :member
    resources :answers, shallow: true, only: %i[create update destroy], concerns: %i[votable commentable],
                        defaults: { votable: 'answers' } do
      member do
        patch :set_best
      end
    end
  end
  root to: 'questions#index'
end
