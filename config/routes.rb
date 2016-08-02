Rails.application.routes.draw do

  root to: 'landing#index'
  get :carson, to: 'page#contact'
  get :facebook, to: 'facebook#facebook'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
