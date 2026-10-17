Rails.application.routes.draw do
  namespace :admin do
    resources :articles
    root to: 'articles#index'
  end
end
