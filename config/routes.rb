Rails.application.routes.draw do
  resources :documents
  # get 'welcome/index'
  root "welcome#index"
  # root to: "welcome#index"
  
  resources :quotations
  resources :invoice_items
  resources :invoices
  resources :milestones
  resources :projects

  get '/invoices/:id/pdf', to: 'invoices#pdf'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
