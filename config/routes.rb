Rails.application.routes.draw do
  get "channels/index"
  get "channels/new"
  get "channels/create"
  root "contents#index"

  # サインアップ
  get "signup", to: "users#new", as: :signup
  resources :users, only: [ :create ]

  # ログイン
  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # チャンネル登録画面
  resources :channels, only: [ :index, :new, :create]

  # その他（健康チェックやPWA関連）
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
