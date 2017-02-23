Rails.application.routes.draw do

  root 'greet#guest'
  
  get 'greet/guest'
  get 'greet/member'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
