# frozen_string_literal: true
module SolrDocumentExtensions::Work
  extend ActiveSupport::Concern

  def artist
    # TODO: needs to display an AIC.Agent
  end

  def creator_display
    Array(self[Solrizer.solr_name('creator_display', :stored_searchable)]).first
  end

  def credit_line
    Array(self[Solrizer.solr_name('credit_line', :stored_searchable)]).first
  end

  def date_display
    Array(self[Solrizer.solr_name('date_display', :stored_searchable)]).first
  end

  def department
    # TODO: need to display an AIC.Department
  end

  def dimensions_display
    Array(self[Solrizer.solr_name('dimensions_display', :stored_searchable)]).first
  end

  def earliest_year
    Array(self[Solrizer.solr_name('earliest_year', :stored_searchable)]).first
  end

  def exhibition_history
    Array(self[Solrizer.solr_name('exhibition_history', :stored_searchable)]).first
  end

  def gallery_location
    Array(self[Solrizer.solr_name('gallery_location', :stored_searchable)]).first
  end

  def inscriptions
    Array(self[Solrizer.solr_name('inscriptions', :stored_searchable)]).first
  end

  def latest_year
    Array(self[Solrizer.solr_name('latest_year', :stored_searchable)]).first
  end

  def main_ref_number
    Array(self[Solrizer.solr_name('main_ref_number', :stored_searchable)]).first
  end

  def medium_display
    Array(self[Solrizer.solr_name('medium_display', :stored_searchable)]).first
  end

  def object_type
    Array(self[Solrizer.solr_name('object_type', :stored_searchable)]).first
  end

  def place_of_origin
    Array(self[Solrizer.solr_name('place_of_origin', :stored_searchable)]).first
  end

  def provenance_text
    Array(self[Solrizer.solr_name('provenance_text', :stored_searchable)]).first
  end

  def publication_history
    Array(self[Solrizer.solr_name('publication_history', :stored_searchable)]).first
  end

  def publ_ver_level
    Array(self[Solrizer.solr_name('publ_ver_level', :stored_searchable)]).first
  end
end
