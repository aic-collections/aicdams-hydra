# frozen_string_literal: true
module SolrDocumentExtensions::Resource
  extend ActiveSupport::Concern

  def batch_uid
    Array(self[Solrizer.solr_name('batch_uid', :stored_searchable)]).first
  end

  def contributors
    Array(self[Solrizer.solr_name('contributors', :stored_searchable)])
  end

  def created_by
    Array(self[Solrizer.solr_name('batch_uid', :stored_searchable)]).first
  end

  def uid
    Array(self[Solrizer.solr_name('uid', :symbol)]).first
  end

  def language
    Array(self[Solrizer.solr_name('language', :stored_searchable)])
  end

  def publisher
    Array(self[Solrizer.solr_name('publisher', :stored_searchable)])
  end

  def rights
    Array(self[Solrizer.solr_name('rights', :stored_searchable)])
  end

  def rights_statement
    Array(self[Solrizer.solr_name('rights_statement', :stored_searchable)])
  end

  def rights_holder
    Array(self[Solrizer.solr_name('rights_holder', :stored_searchable)])
  end

  def alt_label
    Array(self[Solrizer.solr_name('alt_label', :stored_searchable)])
  end
end
