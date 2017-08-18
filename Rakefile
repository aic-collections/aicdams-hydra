# frozen_string_literal: true
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'resque/tasks'

Rails.application.load_tasks
unless Rails.env.production?
  load File.expand_path('../tasks/dev.rake', __FILE__)
  load File.expand_path('../tasks/test.rake', __FILE__)
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
end
