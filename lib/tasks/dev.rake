require 'active_fedora/cleaner'
require 'jettywrapper'
require './spec/support/fixture_loader'
require './spec/support/list_loader'
require 'rubocop/rake_task' unless Rails.env.production?

class DevelopmentLoader
  include FixtureLoader
  include ListLoader
end

Jettywrapper.hydra_jetty_version = "v8.5.0"

unless Rails.env.production?
  desc 'Run style checker'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.requires << 'rubocop-rspec'
    task.fail_on_error = true
  end
end

desc "Run continuous integration test"
task ci: [:rubocop, 'aic:jetty:prep', 'db:migrate'] do
  jetty_params = Jettywrapper.load_config
  error = Jettywrapper.wrap(jetty_params) do
    Rake::Task['spec'].invoke
  end
  raise "test failures: #{error}" if error
end

desc "Clean out development environment"
task clean: ['jetty:empty', 'db:drop', 'db:migrate']

namespace :jetty do

  desc "Empty out jetty of all its records"
  task empty: :environment do
    raise "You can't do this in production" if Rails.env.match("production")
    ActiveFedora::Cleaner.clean!
  end

end

namespace :fedora do
  desc "Register namespace prefixes in Fedora"
  task :config do
    puts "Registering namespace prefixes in Fedora"
    system("script/fedora_config.sh")
  end

  desc "Create fixture resources in Fedora from turtle files"
  task load_fixtures: :environment do
    ActiveFedora::Cleaner.clean!
    loader = DevelopmentLoader.new
    Dir.glob("spec/fixtures/*.ttl").each do |f|
      loader.load_fedora_fixture(f, true)
    end
    loader.load_lists
  end

  desc "Load lists into Fedora"
  task load_lists: :environment do
    DevelopmentLoader.new.load_lists
  end
end

namespace :aic do

  namespace :jetty do

    desc "Clean and prepare jetty"
    task prep: ['jetty:clean', 'sufia:jetty:download_jars'] do
      `cp jetty_config/jetty.xml jetty/etc/`
      `cp jetty_config/keystore jetty/etc/`
    end

    desc "Configure solr"
    task :solr_config do
      `cp solr_conf/solr.xml jetty/solr/solr.xml`
      `rm -Rf jetty/solr/*-core`
      `rm -Rf jetty/solr/aic-*`
      `mkdir jetty/solr/aic-development`
      `mkdir jetty/solr/aic-test`
      `mkdir jetty/solr/aic-production`
      `cp -R solr_conf/conf jetty/solr/aic-development`
      `cp -R solr_conf/conf jetty/solr/aic-test`
      `cp -R solr_conf/conf jetty/solr/aic-production`
    end

  end

end
