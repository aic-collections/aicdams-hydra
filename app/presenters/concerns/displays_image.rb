# frozen_string_literal: true
# This gets mixed into FileSetPresenter in order to create
# a canvas on a IIIF manifest
module DisplaysImage
  extend ActiveSupport::Concern

  def display_image
    return nil unless FileSet.exists?(id)

    url = DerivativePath.access_path(id)
    # byebug
    # check the object's asset type in order to determine if we
    # go ahead with riiif server or just the derivative server and rails. jp2 means riiif and pdf (and the rest that will be added) means regular rails. but, this needs to be done at the controller level, in order to load the correct partial - the one with the uv tag or the one without.

    IIIFManifest::DisplayImage.new(url, width: 640, height: 480, iiif_endpoint: iiif_endpoint(id))
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
