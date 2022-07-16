Rails.application.routes.draw do
  devise_for :members, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  scope module: :public do
    root to: 'posts#index'
    resource :members, only: [:edit, :update]
    get 'members/confirm' => 'members#confirm'
    get 'members/likes' => 'members#likes'
    get "members/mypage" => "members#show"
    get "members/unsubscribe" => "members#unsubscribe"
    patch "members/withdraw" => "members#withdraw"
    resources :posts do
      resource :likes, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
    get "sort_new" => "posts#index"
    get "sort_old" => "posts#index"
    get "sort_like" => "posts#index"
    get "search" => "searches#search"
    resources :tags, except: [:index, :show, :edit, :new, :create, :update, :destroy] do
      get 'posts', to: 'posts#search'
    end
    resources :notifications, only: [:index] do
      collection do
        delete 'destroy_all'
      end
    end
  end

  devise_scope :member do
    get 'members/guest_sign_in', to: 'members/sessions#guest_sign_in'
  end

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  namespace :admin do
    root "posts#index"
    resources :posts, only: [:show, :index] do
      resource :comments, only: [:destroy]
    end
    resources :members, only: [:index, :show, :update]
    get "search" => "searches#search"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
