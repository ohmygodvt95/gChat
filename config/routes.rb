Rails.application.routes.draw do
  mount ActionCable.server => "/cable"

  root "static_pages#show", act: "home"
  get "/pages/:act" => "static_pages#show"

  resources :chat, only: :index

  namespace :api do
    namespace :v1, defaults: {format: :json} do
      resources :contacts, except: [:new, :show, :edit]
      resources :rooms, except: [:new, :edit]
    end
  end

  devise_for :users
end
