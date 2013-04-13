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
  root to: "social_users#index"
end
