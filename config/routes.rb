Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      namespace :analytics do
        get :nps
      end

      namespace :surveys do
        get :comments_conversion
      end

      resources :csv_imports, only: [:create]
    end
  end
end
