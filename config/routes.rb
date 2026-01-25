Rails.application.routes.draw do
  get "password_resets/new"
  get "password_resets/edit"
  get "channels/index"
  get "channels/search"
  get "channels/create"
  root "contents#index"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # サインアップ
  get "signup", to: "users#new", as: :signup
  resources :users, only: [ :create ]

  # ログイン
  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # パスワード再設定
  resources :password_resets, only: [ :new, :create, :edit, :update ]

  # チャンネル登録画面
  resources :channels, only: [ :index, :search, :create]
  
  # チャンネル登録、削除
  resources :user_favorite_channels, only: [:create, :destroy]
  delete "user_favorite_channels", to: "user_favorite_channels#destroy"

  # その他（健康チェックやPWA関連）
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
