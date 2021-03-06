Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'background_tasks/:name', to: 'background_tasks#action'
  post 'background_tasks/:name', to: 'background_tasks#action'

  resources :tests, only: %i(index show)
  resources :users, only: %i(index)

  root 'landings#show'
end
