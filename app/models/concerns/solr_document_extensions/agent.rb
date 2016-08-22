# frozen_string_literal: true
module SolrDocumentExtensions::Agent
  extend ActiveSupport::Concern

  def birth_year
    Array(self[Solrizer.solr_name('birth_year', :stored_searchable)]).first
  end

  def birth_date
    Array(self[Solrizer.solr_name('birth_date', :stored_searchable)]).first
  end

  def death_year
    Array(self[Solrizer.solr_name('death_year', :stored_searchable)]).first
  end

  def death_date
    Array(self[Solrizer.solr_name('death_date', :stored_searchable)]).first
  end
end
