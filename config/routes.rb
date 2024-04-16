Rails.application.routes.draw do
  get 'reports/new'
  get 'reports/index'
  get 'reports/show'
  get 'reports/create'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root to: 'books#index'
  resources :books
  resources :users, only: %i(index show)
end
