Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "users"}
  resources :users

  resources :documents
  # get 'welcome/index'
  root "welcome#index"
  # root to: "welcome#index"

  resources :quotations
  resources :invoice_items
  resources :invoices
  resources :milestones
  resources :projects

  get '/invoices/:id/pdf', to: 'invoices#pdf', as: "download_invoice_pdf"
  get '/invoices/:id/email', to: 'invoices#export_email', as: "download_invoice_email"
  get '/documents/:id/pdf', to: 'documents#pdf', as: "download_document_pdf"
  get '/documents/:id/email', to: 'documents#export_email', as: "download_document_email"
  get '/quotations/:id/pdf', to: 'quotations#pdf', as: "download_quotation_pdf"
  get '/quotations/:id/email', to: 'quotations#export_email', as: "download_quotation_email"

  get '/quotations/:id/create_project', to: 'quotations#create_project', as: "create_project_quotation"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/dashboard' => "dashboard#index", as: "dashboard"
  get '/clients' => "users#clients", as: "clients"

  get '/new_quotation' => "welcome#new_quotation", as: "new_quotation_welcome"
end