Rails.application.routes.draw do
  resources :widgets

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  root 'welcome#index'
  post '/initialize-url/', to: 'external_info#initialize_url'
  post '/submit-url/', to: 'external_info#submit_url'
  post '/submit-sheet-url/', to: 'external_info#submit_sheet_url'
  get '/submit-sheet-url-again/', to: 'external_info#submit_sheet_url'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
