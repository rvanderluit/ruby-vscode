Rails.application.routes.draw do
  get 'home/index'
  root "home#index"

  get 'landing_page', to: "static_pages#landing_page"
  get 'privacy_policy', to: "static_pages#privacy_policy"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end