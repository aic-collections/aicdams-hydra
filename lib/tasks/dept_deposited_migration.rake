# frozen_string_literal: true

namespace :dept_deposited_migration do
  desc "counts GenericWork's in Solr"
  task :count_assets => :environment do
    query = "*:*"
    fq = []
    fq << "has_model_ssim:GenericWork"

    asset_ids = ActiveFedora::SolrService.query( query, { fq: fq, rows: 100_000_000 } ).map(&:id)

    puts "Found #{asset_ids.count} assets in Solr."
  end

  desc "copies all assets' dept_created to dept_deposited"
  task :update_assets => :environment do
    beginning_time = Time.now

    # option 1
    # query = "*:*"
    # fq = []
    # fq << "has_model_ssim:GenericWork"
    #
    # asset_ids = ActiveFedora::SolrService.query( query, { fq: fq, rows: 100_000_000 } ).map(&:id)
    #
    # asset_ids.each do |asset_id|
    #   gw = GenericWork.find(asset_id)
    #   gw.dept_deposited = gw.dept_created.uri
    #   gw.save
    # end
    #
    # end_time = Time.now
    # puts "ActiveFedora::SolrService.query Time elapsed #{(end_time - beginning_time)*1000} milliseconds"

    # # option 2
    GenericWork.all.each do |gw|
      gw.dept_deposited = gw.dept_created.uri
      gw.save
    end

    end_time = Time.now
    puts "GenericWork.all.each Time elapsed #{(end_time - beginning_time)*1000} milliseconds"

    # # option 3
    # GenericWork.find_each do |gw|
    #   gw.dept_deposited = gw.dept_created.uri
    #   gw.save
    # end
    # end_time = Time.now
    # puts "GenericWork.find_each Time elapsed #{(end_time - beginning_time)*1000} milliseconds"
  end
end

#
# beginning_time = Time.now
# (1..10000).each { |i| i }
# end_time = Time.now
# puts "Time elapsed #{(end_time - beginning_time)*1000} milliseconds"
