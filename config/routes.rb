require "sidekiq/web"

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs/v1"
  mount Rswag::Api::Engine => "/api-docs"
  mount Sidekiq::Web => "/sidekiq"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: redirect("/index")

  namespace :api do
    namespace :v1 do
      get     "blogs", to: "blogs#index"
      post    "blogs", to: "blogs#create"
      get     "blogs/:slug", to: "blogs#show"
      put     "blogs/:slug", to: "blogs#update"
      delete  "blogs/:slug", to: "blogs#destroy"
    end
  end

  namespace :docs do
    get "v1", to: redirect("/api-docs/v1")
  end

  get "*path", to: "application#fallback_index_html", constraints: ->(request) do
    !request.xhr? && request.format.html?
  end

end
