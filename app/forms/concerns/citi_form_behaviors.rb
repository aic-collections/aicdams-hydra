# frozen_string_literal: true
module CitiFormBehaviors
  extend ActiveSupport::Concern

  included do
    self.terms += [:document_uris, :representation_uris, :preferred_representation_uri]
    delegate :documents, :document_uris, :representations, :representation_uris,
             :preferred_representation, :preferred_representation_uri, to: :model

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

  def preferred_representation_thumbnail
    return unless preferred_representation
    Sufia::WorkThumbnailPathService.call(preferred_representation)
  end

  def preferred_representation_label
    return unless preferred_representation
    preferred_representation.pref_label
  end

  def preferred_representation_uid
    return unless preferred_representation
    preferred_representation.uid
  end

  # Overrides hydra-editor MultiValueInput#collection
  # Form needs to repond to hash-style arguments for methods defined using ::accepts_uris_for
  def [](term)
    if [:document_uris, :representation_uris].include? term
      send(term)
    else
      super
    end
  end

  def representation_terms
    [:document_uris, :representation_uris, :preferred_representation_uri]
  end
end
