# frozen_string_literal: true
require 'resque/server'

Rails.application.routes.draw do
  mount BrowseEverything::Engine => '/browse'
  mount Blacklight::Engine => '/'

  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  Hydra::BatchEdit.add_routes(self)
  mount CurationConcerns::Engine, at: '/'
  resources :welcome, only: 'index'
  root 'sufia/homepage#index'
  curation_concerns_collections
  curation_concerns_basic_routes
  curation_concerns_embargo_management

  # :index action is not added to concerns, so we're adding it here
  namespace :curation_concerns, path: :concern do
    resources :agents, :exhibitions, :places, :shipments, :transactions, :works, :generic_works, only: [:index]
  end

  curation_concerns_embargo_management
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  # Devise settings
  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    patch 'users/:id' => 'devise/registrations#update', :as => 'user_registration'
  end

  # Administrative URLs
  namespace :admin do
    # Job monitoring
    constraints ResqueAdmin do
      mount Resque::Server, at: 'queues'
    end
  end

  resources :lists, except: [:create, :destroy] do
    resources :list_items, except: [:index, :show]
  end

  resources :autocomplete

  get 'relationships/:model/:id', to: 'relationships#show', as: 'relationship_model'

  # Lakeshore API
  scope "api" do
    post "reindex", to: "reindex#update"
  end

  get "/login_confirm", to: "dummy#login_confirm"

  # Sufia should come last because in production it will 404 any unknown routes
  mount Sufia::Engine => '/'
end
