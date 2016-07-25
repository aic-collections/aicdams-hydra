# frozen_string_literal: true
# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'lakeshore'
set :repo_url, 'https://github.com/aic-collections/aicdams-lakeshore.git'
set :default_branch, 'develop'
set :base_dir, "/usr/local/hydra"
set :aic_config_dir, "#{fetch(:base_dir)}/config"
set :user, 'awead'
set :deploy_to, "#{fetch(:base_dir)}/#{fetch(:application)}"
set :use_sudo, false
set :ssh_options, keys: [File.join(ENV["HOME"], ".ssh", "id_rsa")]
set :aic_proxy, "sysprox.artic.edu:3128"

set :default_env,   path: "$PATH:#{fetch(:base_dir)}/bin",
                    http_proxy: fetch(:aic_proxy).to_s

set :current_release, "#{fetch(:deploy_to)}/current"

# Solr
set :solr_application_dir, "#{fetch(:base_dir)}/solr/current/server"
set :solr_dev_core, 'aic_development'
set :solr_prod_core, 'aic_production'

# Resque
set :resque_pid_file, "#{fetch(:current_release)}/tmp/pids/resque-pool.pid"

# Passenger
# Version 5.0.22 does not work with Shibboleth due to server variables being ignored.
# See https://github.com/phusion/passenger/issues/1707
set :passenger_version, "5.0.21"

set :rails_env, 'production'
set :log_level, :debug
set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"] || fetch(:default_branch).to_s

set :linked_files, fetch(:linked_files, []).push(
  'config/admin.yml',
  'config/blacklight.yml',
  'config/database.yml',
  'config/fedora.yml',
  'config/redis.yml',
  'config/secrets.yml',
  'config/solr.yml'
)
set :linked_dirs, fetch(:linked_dirs, []).push(
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'tmp/derivatives',
  'tmp/uploads',
  'vendor/bundle',
  'public/system'
)
set :keep_releases, 10

# Airbrussh options
set :format_options, command_output: false

namespace :deploy do
  # Create a symlink in the shared directory to the config directory
  # This keeps the configuration files separate from Capistratno's managed deploy directory.
  before 'check:linked_dirs', :link_config do
    on roles(:web) do
      execute "cd #{fetch(:deploy_to)}/shared; ln -sf #{fetch(:aic_config_dir)}"
    end
  end

  after :finished, :post_install_tasks do
    on roles(:web) do
      execute "cd #{fetch(:deploy_to)}/current && /usr/bin/env bundle exec rake rails:update:bin RAILS_ENV=#{fetch(:rails_env)}"
      execute "cd #{fetch(:deploy_to)}/current && touch tmp/restart.txt"
    end
  end
  after :finished, "resque:restart"
end
