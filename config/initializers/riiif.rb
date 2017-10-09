# frozen_string_literal: true
# Copied from samvera-labs/hyku
# Adjusting height and width parameters to match access master dimensions
Riiif::Image.file_resolver = Riiif::HTTPFileResolver.new
Riiif::Image.info_service = lambda do |id, _file|
  fs_id = id
  resp = ActiveFedora::SolrService.get("id:#{fs_id}")
  doc = resp['response']['docs'].first
  raise "Unable to find solr document with id:#{fs_id}" unless doc
  dimensions = DimensionsService.new(width: doc['width_is'], height: doc['height_is'])
  { height: dimensions.height, width: dimensions.width }
end

Riiif::Image.file_resolver.id_to_uri = lambda do |id|
  url = DerivativePath.access_path(id)
  Rails.logger.info "Riiif resolved #{id} to #{url}"
  url
end

Riiif::Image.authorization_service = IIIFAuthorizationService

Riiif.not_found_image = 'app/assets/images/us_404.svg'
Riiif::Engine.config.cache_duration_in_days = 365