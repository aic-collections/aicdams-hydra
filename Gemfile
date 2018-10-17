source 'https://rubygems.org'

gem 'rails', '4.2.10'

# Hydra Gems
gem 'sufia', '~> 7.2'
gem 'flipflop', git: 'https://github.com/jcoyne/flipflop.git', branch: 'hydra'

gem 'aspect_ratio', git: 'https://github.com/envato/aspect_ratio', branch: 'master'
gem 'blacklight_range_limit'
gem 'coffee-rails', '~> 4.2'
gem 'devise', '~> 4.2'
gem 'devise-guests', '~> 0.5'
gem 'figaro'
gem 'iiif_manifest', '~> 0.2.0'
gem 'jbuilder', '~> 2.6'
gem 'jquery-rails'
gem 'mini_magick', git: 'https://github.com/minimagick/minimagick.git'
gem 'posix-spawn'
gem 'resque-cleaner'
gem 'resque-pool'
gem 'riiif'
gem 'rsolr', '~> 1.1'
gem 'sass-rails', '~> 5.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'uglifier', '~> 3.0'

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug'
  gem 'coveralls', require: false
  gem 'factory_girl_rails', require: false
  gem 'fcrepo_wrapper'
  gem 'jasmine'
  gem 'solr_wrapper'
  gem 'sqlite3'
  gem 'webmock', require: false
  gem 'xray-rails'
end

group :development do
  gem 'capistrano-rails', require: false
  gem 'guard-rspec', require: false
  gem 'rubocop', '~> 0.39.0', require: false
  gem 'rubocop-rspec', '~> 1.4.1', require: false
end

group :test do
  gem 'capybara', '~> 2.8'
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-its'
  gem 'rspec-json_expectations'
  gem 'rspec-rails', '~> 3.5'
  gem 'shoulda-matchers', '~> 3.1'
end

group :production do
  gem 'pg'
end
