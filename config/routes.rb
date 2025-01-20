Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'users/sessions'}
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # root "inicio#index"
  # get '/inicio', to: 'inicio#index'
  root to: 'home#index'
  # devise_scope :user do
  #   root to: 'users/sessions#new', as: :unauthenticated_root
  # end

  resources :users
  resources :home, only: [:index]
  resources :stats, only: [:index]

  resources :students, only: [:index, :new, :create, :destroy] do
    collection do
      post :import
    end
  end

  get '/students/download_csv', to: 'students#download_csv', as: 'download_csv'

  resources :records do
    collection do
      post :import
    end
  end

end
