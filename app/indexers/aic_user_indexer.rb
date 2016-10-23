# frozen_string_literal: true
class AICUserIndexer < ActiveFedora::IndexingService
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc["status_bsi"] = object.active?
    end
  end
end
