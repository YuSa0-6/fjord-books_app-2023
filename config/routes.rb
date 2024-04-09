Rails.application.routes.draw do
  root to: 'books#index'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations' ,
    passwords: 'users/passwords'
  }
  resources :books
  resources :users, :only => [:index, :show]

  if Rails.env.development?
    mount LetterOpener::Engine, at: "/letter_opener"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
