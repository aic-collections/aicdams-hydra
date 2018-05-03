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
  desc "Counts the number assets that have been modified after a certain date 'YYYY-MM-DD', are preferred reps, and have an imaging uid"
  task :count_assets_to_update, [:modified_after] => :environment do |_t, args|
    date_passed_in = args[:modified_after]
    new_solr_date = date_passed_in + "T00:00:00Z"

    query = "{!join from=preferred_representation_ssim to=id}preferred_representation_ssim:*"
    fq = []
    fq << "has_model_ssim:GenericWork"
    fq << "system_modified_dtsi:[#{new_solr_date} TO NOW]"

    asset_ids = ActiveFedora::SolrService.query( query, { fq: fq, rows: 100_000 } ).map(&:id)

    puts "Found #{asset_ids.count} preferred rep assets in Solr, edited after #{args[:modified_after]}."
  end

  desc "Send image_uid notifications to CITI for assets that have been modified since a certain date 'YYYY-MM-DD'"
  task :update_imaging_uids, [:modified_after] => :environment do |_t, args|
    date_passed_in = args[:modified_after]
    new_solr_date = date_passed_in + "T00:00:00Z"

    query = "{!join from=preferred_representation_ssim to=id}preferred_representation_ssim:*"
    fq = []
    fq << "has_model_ssim:GenericWork"
    fq << "system_modified_dtsi:[#{new_solr_date} TO NOW]"

    asset_ids = ActiveFedora::SolrService.query( query, { fq: fq, rows: 100_000 } ).map(&:id)

    puts "Found #{asset_ids.count} preferred rep assets in Solr, edited after #{args[:modified_after]}."

    asset_ids.map{ |id| GenericWork.find(id) }.each do |generic_work_object|
      intermediate_file_set = generic_work_object.intermediate_file_set.first
      puts "Enqueueing CitiNotificationJob for #{generic_work_object.try(:title)}"
      CitiNotificationJob.perform_later(intermediate_file_set, nil, true)
    end
  end
end

# GenericWork.where("system_modified_dtsi:[NOW/DAY TO NOW]")
# https://lucene.apache.org/solr/guide/7_3/working-with-dates.html
# GenericWork.where("system_modified_dtsi:[2018-02-28 TO NOW]")
# 2018-02-28T00:00:00Z
