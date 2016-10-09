source 'https://rubygems.org'

gem 'rails', '4.2.7.1'

# Hydra Gems
gem 'sufia', github: 'projecthydra/sufia', ref: '818cb4ca53d81fdb37835a0cd7c753d66eacd679'
gem 'flipflop', git: 'https://github.com/jcoyne/flipflop.git', branch: 'hydra'

# remove when hydra-editor 3.1.2 is released
gem 'hydra-editor', github: 'projecthydra/hydra-editor', ref: 'fc20b8d4c0cf1fcd847208e330c2203a03ed073f'

gem 'blacklight_range_limit'
gem 'coffee-rails', '~> 4.2'
gem 'devise', '~> 4.2'
gem 'devise-guests', '~> 0.5'
gem 'jbuilder', '~> 2.6'
gem 'jquery-rails'
gem 'resque-pool'
gem 'rsolr', '~> 1.1'
gem 'sass-rails', '~> 5.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'turbolinks'
gem 'uglifier', '~> 3.0'
gem 'openseadragon', '~> 0.3'

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug'
  gem 'factory_girl_rails', require: false
  gem 'fcrepo_wrapper'
  gem 'jasmine'
  gem 'solr_wrapper'
  gem 'sqlite3'
  gem 'xray-rails'
end

group :development do
  gem 'capistrano-rails', require: false
  gem 'rubocop', '~> 0.39.0', require: false
  gem 'rubocop-rspec', '~> 1.4.1', require: false
end

group :test do
  gem 'capybara', '~> 2.8'
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-its'
  gem 'rspec-rails', '~> 3.5'
  gem 'shoulda-matchers', '~> 3.1'
end

group :production do
  gem 'pg'
end
