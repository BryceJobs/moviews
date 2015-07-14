Rails.application.routes.draw do

  devise_for :users
  
  resources :movies do
  	resources :reviews, only: [:create, :destroy]
  	get "search_imdb", on: :new
  	post "save_imdb/:imdb_id", on: :collection, action: "save_imdb", as: "save_from_imdb"
 
  end

  root 'movies#index'

end
