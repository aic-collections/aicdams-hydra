# frozen_string_literal: true
class ManifestService
  attr_reader :presenter

  # @param [AssetPresenter] presenter
  def initialize(presenter)
    @presenter = presenter
  end

  # @param [String] image
  def image_url(image)
    "/downloads/#{file_set.id}?file=#{image}"
  end

  # @return [SolrDocument]
  # File set of the related image assigned to the asset, or a null pattern object
  def file_set
    SolrDocument.find(presenter.related_image_id)
  rescue Blacklight::Exceptions::RecordNotFound
    SolrDocument.new
  end

  def text_or_pdf?
    return false if presenter.solr_document.type.include?(AICType.StillImage)
    presenter.solr_document.type.include?(AICType.Text) || file_set.mime_type == "application/pdf"
  end

  # @return [Hash]
  def media_info
    { label: presenter.title.first, thumbnail_url: image_url("thumbnail"), access_url: image_url("accessMaster") }
  end

  # @return [JSON]
  # We need a ManifestFactory object and to be able to add media_sequences to it.
  # Its to_h is connected to a lot of internal state, is not just the creation of a hash
  def manifest_builder
    builder = IIIFManifest::ManifestFactory.new(presenter)
    builder.extend PDFManifestBuilder
    manifest = builder.to_h
    if text_or_pdf?
      builder.add_media_sequences(manifest, media_info)
    else
      JSON.parse(manifest.to_json)
    end
  end
end
