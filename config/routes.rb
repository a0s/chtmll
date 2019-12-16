Rails.application.routes.draw do
  resources :reviews, only: [:index] do
    collection do
      get :avg_by_theme
      get :avg_by_category
    end
  end

  resource :review, only: [:create]
end
