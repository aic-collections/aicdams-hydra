# frozen_string_literal: true
class FileSetPresenter < Sufia::FileSetPresenter
  delegate :rdf_types, :dept_created_citi_uid, to: :solr_document

  def permission_badge_class
    PermissionBadge
  end

  def role
    (rdf_types & available_roles.keys).map { |uri| available_roles[uri].label }
  end

  # @return [IIIFManifest::DisplayImage]
  # Only for the access master
  def display_image
    return unless rdf_types.include?(AICType.IntermediateFileSet)

    original_file = ::FileSet.find(id).original_file

    latest_file_id = original_file.has_versions? ? ActiveFedora::File.uri_to_id(original_file.versions.last.uri) : original_file.id

    encoded_id = ActionDispatch::Journey::Router::Utils.escape_segment(latest_file_id)

    IIIFManifest::DisplayImage.new(DerivativePath.access_path(id),
                                   width: adjusted_dimensions.width,
                                   height: adjusted_dimensions.height,
                                   iiif_endpoint: iiif_endpoint(encoded_id))
  end

  private

    # AICType.find doesn't seem work, so we have to do some key/value matching in order
    # to map AICType uris back to their terms.
    def available_roles
      {
        AICType.IntermediateFileSet.to_s       => AICType.IntermediateFileSet,
        AICType.OriginalFileSet.to_s           => AICType.OriginalFileSet,
        AICType.PreservationMasterFileSet.to_s => AICType.PreservationMasterFileSet,
        AICType.LegacyFileSet.to_s             => AICType.LegacyFileSet
      }
    end

    # @todo There should be a riiif route for this
    def base_image_url(fileset_id)
      uri = Riiif::Engine.routes.url_helpers.info_url(fileset_id, host: request.base_url)
      uri.sub(%r{/info\.json\Z}, '')
    end

    def iiif_endpoint(fileset_id)
      IIIFManifest::IIIFEndpoint.new(base_image_url(fileset_id), profile: "http://iiif.io/api/image/2/level2.json")
    end

    # @return [Array<Integer>] resized x and y values
    def adjusted_dimensions
      @adjusted_dimensions ||= DimensionsService.new(width: solr_document.width, height: solr_document.height)
    end
end
