TemplateApp::Application.routes.draw do
  devise_for :users

  match "/auth/:provider/callback" => "social_users#create"

  resources :social_users do
    collection do
      post :mass_destroy
      get :vkontakte
    end
  end

  # post '/message_sets/new'
  resources :message_sets
  resources :messages
  root to: "social_users#index"

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :message_sets, only: :create
      resources :messages, only: :destroy
    end
  end
end
