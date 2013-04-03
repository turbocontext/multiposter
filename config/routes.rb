TemplateApp::Application.routes.draw do
  devise_for :users

  match "/auth/:provider/callback" => "social_users#create"

  resources :social_users do
    collection do
      post :mass_destroy
    end
  end

  # post '/message_sets/new'
  resources :message_sets
  resources :messages
  root to: "social_users#index"
end
