# frozen_string_literal: true
module SolrDocumentExtensions::Exhibition
  extend ActiveSupport::Concern

  def start_date
    Array(self[Solrizer.solr_name('start_date', :stored_searchable)]).first
  end

  def end_date
    Array(self[Solrizer.solr_name('end_date', :stored_searchable)]).first
  end

  def name_official
    Array(self[Solrizer.solr_name('name_official', :stored_searchable)]).first
  end

  def name_working
    Array(self[Solrizer.solr_name('name_working', :stored_searchable)]).first
  end

  def exhibition_type
    Array(self[Solrizer.solr_name('exhibition_type', :stored_searchable)]).first
  end
end
