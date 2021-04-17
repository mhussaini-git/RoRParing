Rails.application.routes.draw do
  root 'parsers#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :parsers, only: :index do
    collection do
      post :parse
    end
  end
end
