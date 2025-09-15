# frozen_string_literal: true

Rails.application.routes.draw do
  root 'courses#index'
  resources :courses, only: %i[index show]
end
