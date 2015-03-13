Cheftab::Application.routes.draw do
  devise_for :users
  resources :reports

  resources :restaurants

  resources :items
  resources :graphs, defaults: {format: 'json'}

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  root 'restaurants#index'

  get '/home' => 'restaurants#index'

  get '/restaurants/:id/connect', to: 'restaurants#connect'

  get '/restaurants/:id/devices/', to: 'restaurants#devices'

  get '/restaurants/:id/upload', to: 'restaurants#upload'

  get '/restaurants/:id/reports', to: 'restaurants#reports'

  get '/restaurants/:id/show', to: 'restaurants#show'

  get '/restaurants/:id/analyze', to: 'restaurants#analyze'

  get '/restaurants/:id/menu', to: 'restaurants#menu'

  get '/apitest' => 'reports#new'

  post '/reports/:user_id/:restaurant_id', to: 'reports#create'

  post '/restaurants/:id/new_item', to: 'restaurants#new_item'

  get '/contact', to: 'inquiry#index'

  get '/inquiry/send_mail', to: 'inquiry#send_mail'

  delete 'reports/:id', to: 'report#delete'

end
