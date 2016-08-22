# frozen_string_literal: true
module SolrDocumentExtensions::Place
  extend ActiveSupport::Concern

  def lat
    Array(self[Solrizer.solr_name('lat', :symbol)]).first
  end

  def long
    Array(self[Solrizer.solr_name('long', :symbol)]).first
  end
end
