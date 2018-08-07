# frozen_string_literal: true

include Rails.application.routes.url_helpers

namespace :derivatives do
  desc "runs CreateDerivativesJob for all MovingImage and Sound intermediate file_sets"
  task sound_and_moving_image_3053: :environment do

    query = "rdf_types_ssim:\"http://definitions.artic.edu/ontology/1.0/type/IntermediateFileSet\""
    fl = "id"
    fq = []
    fq << "{!join from=file_set_ids_ssim to=id}rdf_types_ssim:(\"http://definitions.artic.edu/ontology/1.0/type/MovingImage\" OR \"http://definitions.artic.edu/ontology/1.0/type/Sound\")"
    file_set_ids = ActiveFedora::SolrService.query( query, { fq: fq, rows: 100_000 } ).map(&:id)

    puts "Found #{file_set_ids.count} id's in Solr, that were intermediate file_sets of either MovingImage or Sound assets."

    file_set_ids.each do |file_set_id|
      fs = FileSet.find(file_set_id)
      orignal_file_id = fs.original_file.id
      CreateDerivativesJob.perform_later fs, orignal_file_id

      # path = curation_concerns_file_set_url(fs.id)
      # parent_path = curation_concerns_parent_file_set_url(fs.parent.id, fs.id)
      asset_path = curation_concerns_generic_work_url(fs.parent.id)

      # puts "Enqueued CreateDerivativesJob for fileset: #{path}"
      puts "Enqueued CreateDerivativesJob for access master for asset: #{asset_path}"
    end
  end
end
