TemplateApp::Application.routes.draw do
  devise_for :users

  match "/auth/:provider/callback" => "social_users#create"

  resources :social_users do
    collection do
      match :mass_destroy
    end
  end
  root to: "social_users#index"
end
