# frozen_string_literal: true
Riiif::Image.file_resolver = Riiif::HTTPFileResolver.new
Riiif::Image.info_service = lambda do |id, _file|
  # id will point to a pcdm:file
  # TODO -- get this info from the access_master file that we serve. For now, that file is set to same dimensions as the one this id points to in Fedora, but that is not safe to rely on.
  fs_id = id
  resp = ActiveFedora::SolrService.get("id:#{fs_id}")
  doc = resp['response']['docs'].first
  raise "Unable to find solr document with id:#{fs_id}" unless doc
  { height: doc['height_is'], width: doc['width_is'] }
end

def logger
  Rails.logger
end

Riiif::Image.file_resolver.id_to_uri = lambda do |id|
  url = DerivativePath.access_path(id)
  logger.info "Riiif resolved #{id} to #{url}"
  url
end

Riiif::Image.authorization_service = IIIFAuthorizationService

Riiif.not_found_image = 'app/assets/images/us_404.svg'
Riiif::Engine.config.cache_duration_in_days = 365
