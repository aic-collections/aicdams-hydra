# frozen_string_literal: true
# This gets mixed into FileSetPresenter in order to create
# a canvas on a IIIF manifest
module DisplaysImage
  extend ActiveSupport::Concern

  def display_image
    return nil unless FileSet.exists?(id)

    url = DerivativePath.access_path(id)
    doc = ActiveFedora::SolrService.get("id:#{id}")
    height = doc["response"]["docs"][0]["height_is"]
    width = doc["response"]["docs"][0]["width_is"]

    IIIFManifest::DisplayImage.new(url, width: width, height: height, iiif_endpoint: iiif_endpoint(id))
  end

  private

    def base_image_url(fileset_id)
      uri = Riiif::Engine.routes.url_helpers.info_url(fileset_id, host: request.base_url)
      # TODO: There should be a riiif route for this:
      uri.sub(%r{/info\.json\Z}, '')
    end

    def iiif_endpoint(fileset_id)
      IIIFManifest::IIIFEndpoint.new(base_image_url(fileset_id), profile: "http://iiif.io/api/image/2/level2.json")
    end
end
