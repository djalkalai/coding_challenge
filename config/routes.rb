CodingChallenge::Application.routes.draw do

  root :to => 'home#start'
  match 'show' => 'home#show'
  match 'index' => 'home#index'
  match 'start' => 'home#start'
  match 'logout' => 'home#logout'

end
