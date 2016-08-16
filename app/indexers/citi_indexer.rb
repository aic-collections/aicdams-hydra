# frozen_string_literal: true
# Indexes resources loaded into Fedora from CITI.
class CitiIndexer < ActiveFedora::IndexingService
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc["read_access_group_ssim"] = ["group", "registered"]
      solr_doc[Solrizer.solr_name("aic_type", :facetable)] = object.class.to_s
      solr_doc[Solrizer.solr_name("resource_type", :stored_searchable)] = object.class.to_s
      solr_doc[Solrizer.solr_name("status", :symbol)] = [object.status.pref_label] if object.status
      solr_doc[Solrizer.solr_name("documents", :symbol)] = object.documents.map(&:id)
      solr_doc[Solrizer.solr_name("representations", :symbol)] = object.representations.map(&:id)
      solr_doc[Solrizer.solr_name("preferred_representation", :symbol)] = object.preferred_representation.id if object.preferred_representation
      solr_doc[Solrizer.solr_name("relationships", :stored_searchable, type: :integer)] = relationship_count
    end
  end

  private

    def relationship_count
      count = object.documents.length + object.representations.length
      count + 1 if object.preferred_representation
      count
    end
end
