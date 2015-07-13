CodingChallenge::Application.routes.draw do

  root :to => 'home#index'
  match 'show' => 'home#show'
  match 'index' => 'home#index'

end
