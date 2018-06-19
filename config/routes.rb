Rails.application.routes.draw do
  # get 'welcome/index'
  root "welcome#index"
  # root to: "welcome#index"
  
  resources :quotations
  resources :invoice_items
  resources :invoices
  resources :milestones
  resources :projects
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
