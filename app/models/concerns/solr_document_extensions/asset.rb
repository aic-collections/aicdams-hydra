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

  def publish_channels
    Array(self[Solrizer.solr_name('publish_channels', :symbol)])
  end

  def view_notes
    Array(self[Solrizer.solr_name('view_notes', :stored_searchable)])
  end

  def visual_surrogate
    Array(self[Solrizer.solr_name('visual_surrogate', :stored_searchable)]).first
  end

  def external_resources
    Array(self[Solrizer.solr_name('external_resources', :stored_searchable)])
  end

  def copyright_representatives
    Array(self[Solrizer.solr_name('copyright_representatives', :stored_searchable)])
  end

  def licensing_restrictions
    Array(self[Solrizer.solr_name('licensing_restrictions', :stored_searchable)])
  end

  def public_domain?
    Array(self["public_domain_bsi"]).first
  end

  def publishable?
    Array(self["publishable_bsi"]).first
  end

  def caption
    Array(self[Solrizer.solr_name('caption', :stored_searchable)]).first
  end

  def intermediate_file_set
    Array(self[Solrizer.solr_name('intermediate_ids', :symbol)]).first
  end

  def preservation_file_set
    Array(self[Solrizer.solr_name('preservation_ids', :symbol)]).first
  end

  def original_file_set
    Array(self[Solrizer.solr_name('original_ids', :symbol)]).first
  end

  def legacy_file_set
    Array(self[Solrizer.solr_name('legacy_ids', :symbol)]).first
  end
end
