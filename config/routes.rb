Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "thread", to: "thred#index"
  get "thread/:id", to: "thred#show"
  get "thread/upvote/:id", to: "thred#upvote"
  get "thread/downvote/:id", to: "thred#downvote"
  post "thread", to: "thred#create"
  post "thread/:id", to: "thred#followup"
  patch "thread/:id", to: "thred#update"
  put "thread/:id", to: "thred#update"
  delete "thread/:id", to: "thred#destroy"  

  resources :category, only:[:index, :show]
  resources :followup, only:[:show, :update, :destroy]
  get "followup/upvote/:id", to: "followup#upvote"
  get "followup/downvote/:id", to: "followup#downvote"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
