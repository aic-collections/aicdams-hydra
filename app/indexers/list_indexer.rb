# frozen_string_literal: true
class ListIndexer < ActiveFedora::IndexingService
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc[Solrizer.solr_name("types", :symbol)] = object.type.map(&:to_s)
    end
  end
end
