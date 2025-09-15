Rails.application.routes.draw do
  root "courses#index"
  resources :courses, only: [:index, :show]
end
