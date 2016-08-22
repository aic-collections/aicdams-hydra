# frozen_string_literal: true
# Tells us what CITI resources a given asset is representing.
class RepresentingResource
  extend Deprecation
  attr_reader :id

  # @param asset [String, GenericWork] the asset in question
  def initialize(asset)
    Deprecation.warn(RepresentingResource, 'RepresentingResource is deprecated use InboundRelationships instead')
    return unless asset
    @id = asset.is_a?(String) ? asset : asset.id
  end

  def representing?
    !(documents.empty? && preferred_representation.nil? && representations.empty?)
  end

  def documents
    @documents ||= objects_with_predicate(:documents_ssim)
  end

  def preferred_representation
    @preferred_representation ||= object_with_predicate(:preferred_representation_ssim)
  end

  def representations
    @representations ||= objects_with_predicate(:representations_ssim)
  end

  private

    def objects_with_predicate(solr_field)
      return [] if id.nil?
      ActiveFedora::Base.where(solr_field => id)
    end

    def object_with_predicate(solr_field)
      return if id.nil?
      ActiveFedora::Base.where(solr_field => id).first
    end
end
