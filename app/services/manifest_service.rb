# frozen_string_literal: true
require 'iiif_manifest'

module PDFManifestBuilder
  def add_media_sequences(manifest, media_info)
    json_manifest = JSON.parse(manifest.to_json)
    json_manifest["mediaSequences"] = [media_sequence(media_info)]
    json_manifest["@context"] = ["http://iiif.io/api/image/2/context.json", "http://wellcomelibrary.org/ld/ixif/0/context.json"]
    json_manifest
  end

  def media_sequence(media_info)
    @elements ||=
      begin
        elements = {}
        elements["@id"] = media_info[:access_url]
        elements["format"] = "application/pdf"
        elements["@type"] = "foaf:Document"
        elements["label"] = media_info[:label]
        elements["rendering"] = [{
          "@id": media_info[:access_url],
          "format": "application/pdf",
          "label": media_info[:label]
        }]
        elements["thumbnail"] = media_info[:thumbnail_url]
      end
    @media_sequence ||=
      begin
        media_sequence = {}
        media_sequence["@type"] ||= "ixif:MediaSequence"
        media_sequence["label"] ||= "Contents"
        media_sequence["rendering"] = []
        media_sequence["elements"] = [elements]
        media_sequence
      end
  end
end

class ManifestService
  def initialize(presenter)
    @presenter = presenter
    @media_info = { label: presenter.title.first, thumbnail_url: image_url("thumbnail"), access_url: image_url("accessMaster") }
  end

  def image_url(image)
    "https://#{ENV['LAKESHORE_DOMAIN']}/downloads/#{file_set_id}?file=#{image}"
  end

  def file_set_id
    @presenter.solr_document["hasRelatedImage_ssim"].first
  end

  def media_is_pdf?
    FileSet.find(file_set_id).to_solr["file_format_sim"].include?("pdf (Portable Document Format)")
  end

  def manifest_builder
    # we need a ManifestFactory object and to be able to add media_sequences to it; its to_h is connected to a lot of internal state, is not just the creation of a hash
    builder = IIIFManifest::ManifestFactory.new(@presenter)
    builder.extend PDFManifestBuilder
    manifest = builder.to_h
    if media_is_pdf?
      builder.add_media_sequences(manifest, @media_info)
    else
      JSON.parse(manifest.to_json)
    end
  end
end
