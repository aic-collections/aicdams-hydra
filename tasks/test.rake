require 'rspec/core'
require 'rspec/core/rake_task'
require 'solr_wrapper'
require 'fcrepo_wrapper'
require 'active_fedora/rake_support'
require 'rubocop/rake_task'

namespace :test do
  desc "Run all feature tests"
  RSpec::Core::RakeTask.new(:feature) do |t|
    t.pattern = FileList['spec{,/features/**}/*_spec.rb']
    t.rspec_opts = ['--color', '--backtrace']
  end

  desc "Run all tests except features"
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = FileList['spec/**/*_spec.rb'].exclude("spec/features/**/*_spec.rb")
    t.rspec_opts = ['--color', '--backtrace']
  end
end

namespace :ci do
  desc "Run Rubocop during continuous integration build"
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.requires << "rubocop-rspec"
    task.fail_on_error = true
  end

  desc "Run unit tests during continuous integration build"
  task unit: :environment do
    Rake::Task["db:migrate"].invoke
    with_test_server do
      Rake::Task["test:unit"].invoke
    end
  end

  desc "Run feature tests during continuous integration build"
  task feature: :environment do
    Rake::Task["db:migrate"].invoke
    with_test_server do
      Rake::Task["test:feature"].invoke
    end
  end

  desc "Run Jasmine tests during continuous integration build"
  task jasmine: :environment do
    Rake::Task["db:migrate"].invoke
    with_test_server do
      Rake::Task["jasmine:ci"].invoke
    end
  end
end
