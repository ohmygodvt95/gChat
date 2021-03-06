Rails.application.routes.draw do
  mount ActionCable.server => "/cable"

  root "static_pages#show", act: "home"
  get "/pages/:act" => "static_pages#show"

  resources :chat, only: :index

  namespace :api do
    namespace :v1, defaults: {format: :json} do
      resources :contacts, except: [:new, :show, :edit]
      resources :tasks, only: [:index]
      resources :rooms, except: [:new, :edit] do
        resources :messages, except: [:new, :edit] do
          resources :replies, only: :update
          resources :mentions, only: :update
        end
        resources :invite, only: [:index, :create]
        resource :leave, only: :destroy
        resource :user_rooms, only: :update
        resources :tasks, except: [:new, :show, :edit]
      end
    end
  end

  devise_for :users
end
