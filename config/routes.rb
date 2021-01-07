Rails.application.routes.draw do

  get '/' => 'home#index'

  # place関連
  get 'place' => 'place#index'
  get 'place/search' => 'place#search'
  get 'place/new' => 'place#new'
  post 'place/create' => 'place#create'
  get "place/:area" => 'place#show'

  get "search_exe" => 'place#search'


end
