# frozen_string_literal: true
class CitiResource < Resource
  include CitiResourceMetadata
  include Sufia::WithEvents

  def self.aic_type
    super << AICType.CitiResource
  end

  type aic_type

  around_save :reindex_relations

  # Status defaults to active if it is nil
  def status
    super || StatusType.active
  end

  # Re-indexes related objects, i.e. representations, preferred representation, and documents, including
  # those of relations that have just been removed. To do so, we need to query for these relationships
  # in solr, which still exist prior to calling #save.
  def reindex_relations
    ids = solr_relation_ids + relation_ids
    yield
    ids.uniq.map { |id| ActiveFedora::Base.find(id).update_index }
  end

  private

    def relation_ids
      ids = [documents.map(&:id), representations.map(&:id)].flatten
      ids << preferred_representation.id if preferred_representation
      ids
    end

    def solr_relation_ids
      return [] if id.nil?
      ActiveFedora::SolrService.query(
        "id:#{id}",
        fl: "documents_ssim, preferred_representation_ssim, representations_ssim"
      ).first.values.flatten
    end
end
