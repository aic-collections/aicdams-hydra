# frozen_string_literal: true
module SolrDocumentExtensions::Asset
  extend ActiveSupport::Concern

  def capture_device
    Array(self[Solrizer.solr_name('capture_device', :stored_searchable)]).first
  end

  def digitization_source
    Array(self[Solrizer.solr_name('digitization_source', :stored_searchable)]).first
  end

  def document_types
    Array(self[Solrizer.solr_name('document_types', :stored_searchable)]).first
  end

  def legacy_uid
    Array(self[Solrizer.solr_name('legacy_uid', :stored_searchable)])
  end

  def keyword
    Array(self[Solrizer.solr_name('keyword', :stored_searchable)])
  end

  def compositing
    Array(self[Solrizer.solr_name('compositing', :stored_searchable)]).first
  end

  def imaging_uid
    Array(self[Solrizer.solr_name('imaging_uid', :symbol)])
  end

  def light_type
    Array(self[Solrizer.solr_name('light_type', :stored_searchable)]).first
  end

  def view
    Array(self[Solrizer.solr_name('view', :stored_searchable)])
  end

  def transcript
    Array(self[Solrizer.solr_name('transcript', :stored_searchable)]).first
  end
end
