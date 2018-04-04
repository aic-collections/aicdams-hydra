# frozen_string_literal: true
class Resource < ActiveFedora::Base
  def self.aic_type
    [AICType.Resource]
  end

  include AcceptsUris
  include BasicMetadata
  include ResourceMetadata
  include WithStatus

  type aic_type

  around_save :reindex_relations

  # Re-indexes related objects, i.e. representations, preferred representation, documents, and attachments
  # including those of relations that have just been removed. To do so, we need to query for these relationships
  # in solr, which still exist prior to calling #save.
  def reindex_relations
    ids = solr_relation_ids + relation_ids
    yield
    ids.uniq.map { |id| reindex_related_resource(id) }
  end

  private

    # Returns the correct type class for attributes when loading an object from Solr
    # Catches malformed dates that will not parse into DateTime, see #198
    def adapt_single_attribute_value(value, attribute_name)
      AttributeValueAdapter.call(value, attribute_name) || super
    rescue ArgumentError
      "#{value} is not a valid date"
    end

    def relation_ids
      ids = [documents.map(&:id), representations.map(&:id), attachment_ids, constituent_ids].flatten
      ids << preferred_representation.id if preferred_representation
      ids
    end

    def solr_relation_ids
      return [] if id.nil?
      ActiveFedora::SolrService.query(
        "id:#{id}",
        fl: "documents_ssim, preferred_representation_ssim, representations_ssim, attachments_ssim, constituent_of_ssim"
      ).first.values.flatten
    end

    def attachment_ids
      return [] unless respond_to?(:attachments)
      attachments.map(&:id)
    end

    def constituent_ids
      return [] unless respond_to?(:constituent_of)
      constituent_of.map(&:id)
    end

    def reindex_related_resource(id)
      ActiveFedora::Base.find(id).update_index
    rescue ActiveFedora::ObjectNotFoundError
      Rails.logger.warn("Attempted to reindex related resource #{id}, but it was not found in Fedora.")
    end
end
