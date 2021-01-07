Rails.application.routes.draw do

  # TOP
  get '/' => 'home#index'

  # 認証関連
  get "signup" => "users#new"
  get "login" => "users#login_form"
  post "login" => "users#login"
  post "logout" => "users#logout"


  # ユーザー関連
  get "users" => "users#index"
  get "users/:id/edit" => "users#edit"
  post "users/create" => "users#create"
  get "users/:id" => "users#show"

  # place関連
  get 'place' => 'place#index'
  get 'place/search' => 'place#search'
  get 'place/new' => 'place#new'
  post 'place/create' => 'place#create'
  get "place/edit" => 'place#edit'
  post "place/:id/update" => 'place#update'
  post "place/:id/delete" => 'place#delete'
  get "place/:area" => 'place#show'

  # 検索関連
  get "search_exe" => 'place#search'


end
