require 'rspec/core'
require 'rspec/core/rake_task'
require 'solr_wrapper'
require 'fcrepo_wrapper'
require 'active_fedora/cleaner'
require 'active_fedora/rake_support'
require 'rubocop/rake_task'
require 'factory_girl_rails'

desc 'Run style checker'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop-rspec'
  task.fail_on_error = true
end

desc "Run continuous integration test"
task ci: [:rubocop, 'db:migrate'] do
  with_test_server do
    Rake::Task['spec'].invoke
  end
end

namespace :dev do
  desc "Clean out Solr and Fedora"
  task clean: :environment do
    ActiveFedora::Cleaner.clean!
  end

  desc "Prep dev environment"
  task prep: ['db:migrate', :clean, 'lakeshore:load_lists', 'fedora:create_users', 'fedora:create_citi_resources']
end

namespace :fedora do
  desc "Register namespace prefixes in Fedora"
  task :config do
    puts "Registering namespace prefixes in Fedora"
    system("script/fedora_config.sh")
  end

  desc "Create test users for AIC testing specifically, dependent on local Shibboleth settings"
  task create_users: :environment do
    AICUser.create(nick: "laketest", pref_label: "US-1484", given_name: "lake", family_name: "test")
    AICUser.create(nick: "scossu", pref_label: "US-1117", given_name: "Stefano", family_name: "Cossu")
    AICUser.create(nick: "scossuadmin", pref_label: "US-758", given_name: "[admin] Stefano", family_name: "Cossu")
    AICUser.create(nick: "awead", pref_label: "US-583", given_name: "Adam", family_name: "Wead")
    AICUser.create(nick: "aweadadmin", pref_label: "US--32351", given_name: "[admin] Adam", family_name: "Wead")
    AICUser.create(nick: "tshah", pref_label: "US-1305", given_name: "Tina", family_name: "Shah")
    AICUser.create(nick: "rdoll", pref_label: "US-1211", given_name: "Becca", family_name: "Doll")
    Department.create(citi_uid: "87", pref_label: "Visitor Services")
    Department.create(citi_uid: "112", pref_label: "Information Services")
    Department.create(citi_uid: "6", pref_label: "European Decorative Arts")
  end

  desc "Create sample CITI resources"
  task create_citi_resources: :environment do
    FactoryGirl.create(:agent, :with_sample_metadata)
    FactoryGirl.create(:exhibition, :with_sample_metadata)
    FactoryGirl.create(:work, :with_sample_metadata)
    FactoryGirl.create(:place, :with_sample_metadata)
    FactoryGirl.create(:shipment, :with_sample_metadata)
    FactoryGirl.create(:transaction, :with_sample_metadata)
  end
end
