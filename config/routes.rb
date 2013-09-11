TemplateApp::Application.routes.draw do
  scope "(:locale)", locale: /en|ru/ do
    devise_for :users

    get "/auth/:provider/callback" => "social_users#create"

    resources :social_users do
      collection do
        post :mass_destroy
        get :vkontakte
        get :livejournal
        get :google_plus
        get :odnoklassniki
      end
    end

    # post '/message_sets/new'
    resources :message_sets
    resources :messages
    resources :users

    namespace :api, defaults: { format: 'json' } do
      namespace :v1 do
        resources :message_sets, only: :create
        resources :messages, only: :destroy
      end
    end
  end
  # root to: "social_users#index"
  root to: "message_sets#new"
end
