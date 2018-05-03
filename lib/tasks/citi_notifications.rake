# frozen_string_literal: true
require 'benchmark'

class Rake::Task
  def execute_with_benchmark(*args)
    bm = Benchmark.measure { execute_without_benchmark(*args) }
    puts "   #{name} --> #{bm}"
  end

  alias execute_without_benchmark execute
  alias execute execute_with_benchmark
end

namespace :citi_notifications do
  desc "Send image_uid notifications to CITI for assets that have been modified since a certain date 'YYYY-MM-DD'"
  task :update_imaging_uids, [:modified_after] => :environment do |_t, args|
    # pull out date passed in
    date_passed_in = args[:modified_after]

    # add date to time to create timestamp for solr query
    new_solr_date = date_passed_in + "T00:00:00Z"

    # find the assets edited since a specific date
    solr_docs = GenericWork.where("system_modified_dtsi:[#{new_solr_date} TO NOW]")

    # tell the user how many found
    puts "Found #{solr_docs.count} GenericWork's in Solr, modified since #{date_passed_in}."

    # convert array of solr docs to array of id's
    asset_ids = solr_docs.map(&:id)

    asset_objects_that_are_preferred_reps = []

    # go through all assets in subset 1 and reduce to those that are a preferred
    asset_ids.each do |asset_id|
      inbound_relationship_object = InboundRelationships.new(asset_id)
      asset_objects_that_are_preferred_reps << GenericWork.find(asset_id) if inbound_relationship_object.preferred_representation.present?
    end

    # tell the user how many assets are also a preferred rep
    puts "Found #{asset_objects_that_are_preferred_reps.count} assets that are also a preferred rep."

    asset_objects_that_are_preferred_reps.each do |generic_work_object|
      intermediate_file_set = generic_work_object.intermediate_file_set.first
      puts "Enqueueing CitiNotificationJob for #{generic_work_object.title}"
      CitiNotificationJob.perform_later(intermediate_file_set, nil, true)
    end
  end

  desc "Counts the number assets that have been modified after a certain date 'YYYY-MM-DD', are preferred reps, and have an imaging uid"
  task :count_assets_to_update, [:modified_after] => :environment do |_t, args|
    date_passed_in = args[:modified_after]
    new_solr_date = date_passed_in + "T00:00:00Z"

    solr_docs = GenericWork.where("system_modified_dtsi:[#{new_solr_date} TO NOW]")
    puts "Found #{solr_docs.count} GenericWork's in Solr, modified since #{date_passed_in}."

    asset_ids = solr_docs.map(&:id)
    asset_objects_that_are_preferred_reps = []

    asset_ids.each do |asset_id|
      inbound_relationship_object = InboundRelationships.new(asset_id)
      asset_objects_that_are_preferred_reps << GenericWork.find(asset_id) if inbound_relationship_object.preferred_representation.present?
    end

    puts "Would send #{asset_objects_that_are_preferred_reps.count} notifications to CITI, if ran."
  end
end

# GenericWork.where("system_modified_dtsi:[NOW/DAY TO NOW]")
# https://lucene.apache.org/solr/guide/7_3/working-with-dates.html
# GenericWork.where("system_modified_dtsi:[2018-02-28 TO NOW]")
# 2018-02-28T00:00:00Z
