Rails.application.routes.draw do
  root "static_pages#show", act: "home"
  get "/pages/:act" => "static_pages#show"

  resources :chat, only: :index

  devise_for :users
end
