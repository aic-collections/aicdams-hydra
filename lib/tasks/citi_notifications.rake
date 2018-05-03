namespace :citi_notifications do
  desc "Send image_uid notifications to CITI for assets that have been modified since a certain date 'YYYY-MM-DD'"
  task :update_imaging_uids, [:modified_after] => :environment do |t, args|
    date_passed_in = args[:modified_after]
    new_solr_date = date_passed_in + "T00:00:00Z"

    solr_docs = GenericWork.where("system_modified_dtsi:[#{new_solr_date} TO NOW]")
    puts "Found #{solr_docs.count} GenericWork's in Solr, modified since #{date_passed_in}."

    asset_ids = solr_docs.map(&:id)
    asset_ids_that_are_preferred_reps = []

    asset_ids.each do |asset_id|
      inbound_relationship_object = InboundRelationships.new(asset_id)
      asset_ids_that_are_preferred_reps << asset_id if inbound_relationship_object.preferred_representation.present?
    end

    puts "Found #{asset_ids_that_are_preferred_reps.count} assets that are also a preferred rep."

    asset_objects_that_are_preferred_reps_and_have_an_imaging_uid = []

    asset_ids_that_are_preferred_reps.each do |asset_id|
      gw_object = GenericWork.find(asset_id)
      if gw_object.imaging_uid.present?
        asset_objects_that_are_preferred_reps_and_have_an_imaging_uid << gw_object
      end
    end

    puts "Found #{asset_objects_that_are_preferred_reps_and_have_an_imaging_uid.count} assets that have a non-empty imaging_uid."

    asset_objects_that_are_preferred_reps_and_have_an_imaging_uid.each do |gw|
      intermediate_file_set = gw.intermediate_file_set.first
      puts "Enqueueing CitiNotificationJob for #{gw.title}"
      CitiNotificationJob.perform_later(intermediate_file_set, nil, true)
    end
  end

  desc "Counts the number assets that have been modified after a certain date 'YYYY-MM-DD', are preferred reps, and have an imaging uid"
  task :count_assets_to_update, [:modified_after] => :environment do |t, args|
    date_passed_in = args[:modified_after]
    new_solr_date = date_passed_in + "T00:00:00Z"

    solr_docs = GenericWork.where("system_modified_dtsi:[#{new_solr_date} TO NOW]")
    puts "Found #{solr_docs.count} GenericWork's in Solr, modified since #{date_passed_in}."

    asset_ids = solr_docs.map(&:id)
    asset_ids_that_are_preferred_reps = []

    asset_ids.each do |asset_id|
      inbound_relationship_object = InboundRelationships.new(asset_id)
      asset_ids_that_are_preferred_reps << asset_id if inbound_relationship_object.preferred_representation.present?
    end

    puts "Found #{asset_ids_that_are_preferred_reps.count} assets that are also a preferred rep."

    asset_objects_that_are_preferred_reps_and_have_an_imaging_uid = []

    asset_ids_that_are_preferred_reps.each do |asset_id|
      gw_object = GenericWork.find(asset_id)
      if gw_object.imaging_uid.present?
        asset_objects_that_are_preferred_reps_and_have_an_imaging_uid << gw_object
      end
    end

    puts "Would send #{asset_objects_that_are_preferred_reps_and_have_an_imaging_uid.count} notifications to CITI, if ran."
  end
end


# GenericWork.where("system_modified_dtsi:[NOW/DAY TO NOW]")
# https://lucene.apache.org/solr/guide/7_3/working-with-dates.html
# GenericWork.where("system_modified_dtsi:[2018-02-28 TO NOW]")

# 2018-02-28T00:00:00Z