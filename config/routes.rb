Rails.application.routes.draw do
  devise_for :members, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  scope module: :public do
    root to: 'posts#index'
    resource :members, only: [:edit, :update] do
      member do
        get :likes
      end
    end
    get "members/mypage" => "members#show"
    get "members/unsubscribe" => "members#unsubscribe"
    patch "members/withdraw" => "members#withdraw"
    resources :posts do
      resource :likes, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
    resources :tags, except: [:index, :show, :edit, :new, :create, :update, :destroy] do
      get 'posts', to: 'posts#search'
    end
    get "search" => "searches#search"
    resources :notifications, only: [:index] do
      collection do
        delete 'destroy_all'
      end
    end
  end

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  namespace :admin do
    root "posts#index"
    resources :posts, only: [:show, :index] do
      resource :comments, only: [:destroy]
    end
    get "members" => "members#index"
    get "search" => "searches#search"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
