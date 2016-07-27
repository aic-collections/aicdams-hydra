# frozen_string_literal: true
# Indexes resources loaded into Fedora from CITI.
class CitiIndexer < ActiveFedora::IndexingService
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc["read_access_group_ssim"] = ["group", "registered"]
      solr_doc[Solrizer.solr_name("aic_type", :facetable)] = object.class.to_s
      solr_doc[Solrizer.solr_name("status", :symbol)] = [object.status.pref_label] if object.status
      #solr_doc[Solrizer.solr_name("artist", :symbol)] = [object.artist.pref_label] if object.artist
      #solr_doc[Solrizer.solr_name("department", :symbol)] = [object.department.pref_label] if object.department
      solr_doc[Solrizer.solr_name("documents", :symbol)] = object.documents.map(&:uid)
      solr_doc[Solrizer.solr_name("representations", :symbol)] = object.representations.map(&:uid)
      solr_doc[Solrizer.solr_name("preferred_representation", :symbol)] = object.preferred_representation.uid if object.preferred_representation
    end
  end
end
