require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do

  concern :iiif_search, BlacklightIiifSearch::Routes.new

  mount NewspaperWorks::Engine => '/'
  concern :oai_provider, BlacklightOaiProvider::Routes.new

  mount Riiif::Engine => 'images', as: :riiif if Hyrax.config.iiif_image_server?

  authenticate :user, lambda { |u| u.is_superadmin? || u.is_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  if ActiveModel::Type::Boolean.new.cast(ENV.fetch('HYKU_MULTITENANT', false))
    constraints host: Account.admin_host do
      get '/account/sign_up' => 'account_sign_up#new', as: 'new_sign_up'
      post '/account/sign_up' => 'account_sign_up#create'
      get '/', to: 'splash#index', as: 'splash'

      # pending https://github.com/projecthydra-labs/hyrax/issues/376
      get '/dashboard', to: redirect('/')

      namespace :proprietor do
        resources :accounts
        resources :users
      end
    end
  end

  get 'status', to: 'status#index'

  mount BrowseEverything::Engine => '/browse'
  resource :site, only: [:update] do
    resources :roles, only: [:index, :update]
    resource :labels, only: [:edit, :update]
  end

  #root 'hyrax/homepage#index'
  root 'catalog#index'

  devise_for :users, controllers: { invitations: 'hyku/invitations', registrations: 'hyku/registrations' }

  mount Qa::Engine => '/authorities'

  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'

  mount Hyrax::Engine, at: '/'
  mount Hyrax::DOI::Engine, at: '/doi', as: 'hyrax_doi'
  if ENV.fetch('HYKU_BULKRAX_ENABLED', false)
    mount Bulkrax::Engine, at: '/'
  end

  concern :searchable, Blacklight::Routes::Searchable.new
  concern :exportable, Blacklight::Routes::Exportable.new

  curation_concerns_basic_routes

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :oai_provider

    concerns :searchable
  end

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
    concerns :iiif_search
  end

=begin
  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end
=end

  namespace :admin do
    resource :account, only: [:edit, :update]
    resource :work_types, only: [:edit, :update]
    resources :users, only: [:destroy]
    resources :groups do
      member do
        get :remove
      end

      resources :users, only: [:index], controller: 'group_users' do
        collection do
          post :add
          delete :remove
        end
      end
    end
  end

  get 'all_collections' => 'hyrax/homepage#all_collections', as: :all_collections
end
