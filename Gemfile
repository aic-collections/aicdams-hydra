source 'https://rubygems.org'

gem 'rails', '4.2.7'

# Hydra Gems
gem 'sufia', '~> 7.0'

gem 'blacklight_range_limit'
gem 'coffee-rails', '~> 4.1'
gem 'devise', '~> 3.5'
gem 'devise-guests', '~> 0.5'
gem 'jbuilder', '~> 2.4'
gem 'jquery-rails'
gem 'resque-pool'
gem 'rsolr', '~> 1.1'
gem 'sass-rails', '~> 5.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'turbolinks'
gem 'uglifier', '~> 3.0'
gem 'openseadragon', github: 'IIIF/openseadragon-rails', ref: '684d56ffe1049fe0f637ffe63e78ec9376c3cc29'

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug'
  gem 'factory_girl_rails', require: false
  gem 'fcrepo_wrapper'
  gem 'jasmine'
  gem 'solr_wrapper'
  gem 'sqlite3'
end

group :development do
  gem 'capistrano-rails', require: false
  gem 'rubocop', '~> 0.39.0', require: false
  gem 'rubocop-rspec', '~> 1.4.1', require: false
end

group :test do
  gem 'capybara', '~> 2.7'
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-its'
  gem 'rspec-rails', '~> 3.4'
  gem 'shoulda-matchers', '~> 3.1'
end

group :production do
  gem 'pg'
end
