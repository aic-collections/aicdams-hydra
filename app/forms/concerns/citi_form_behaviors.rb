# frozen_string_literal: true
module CitiFormBehaviors
  extend ActiveSupport::Concern

  included do
    self.terms += [:document_uris, :representation_uris, :preferred_representation_uri]
    delegate :document_uris, :representation_uris, :preferred_representation_uri, to: :model

    def self.multiple?(term)
      return true if [:document_uris, :representation_uris].include? term
      super
    end

    def self.build_permitted_params
      super + [
        { document_uris: [] },
        { representation_uris: [] },
        :preferred_representation_uri
      ]
    end
  end

  # @return [Array<SolrDocument>]
  def documents
    document_uris.map { |s| SolrDocument.find(URI(s).path.split(/\//).last) }
  end

  # @return [Array<SolrDocument>]
  def representations
    rep_uris = representation_uris
    rep_uris.insert(0, preferred_representation_uri).uniq! if preferred_representation_uri
    rep_uris.map { |s| SolrDocument.find(URI(s).path.split(/\//).last) }
  end

  # @return [SolrDocument]
  def preferred_representation
    @preferred_representation = if preferred_representation_uri
                                  SolrDocument.find(URI(preferred_representation_uri).path.split(/\//).last)
                                else
                                  SolrDocument.new({})
                                end
  end

  def preferred_representation_thumbnail
    Sufia::WorkThumbnailPathService.call(preferred_representation)
  end

  # Overrides hydra-editor MultiValueInput#collection
  # Form needs to respond to hash-style arguments for methods defined using ::accepts_uris_for
  def [](term)
    if [:document_uris, :representation_uris].include? term
      send(term)
    else
      super
    end
  end

  def representation_terms
    [:representation_uris, :document_uris]
  end
end
