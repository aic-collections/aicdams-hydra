# frozen_string_literal: true
class WorkIndexer < CitiIndexer
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc[Solrizer.solr_name("artist", :symbol)] = object.artist.first.id if object.artist.first
      solr_doc[Solrizer.solr_name("current_location", :symbol)] = object.current_location.first.id if object.current_location.first
    end
  end
end
