# frozen_string_literal: true
module SolrDocumentExtensions
  extend ActiveSupport::Concern
  include Permissions::Readable

  include SolrDocumentExtensions::Agent
  include SolrDocumentExtensions::Work
  include SolrDocumentExtensions::Exhibition
  include SolrDocumentExtensions::Place
  include SolrDocumentExtensions::Asset
  include SolrDocumentExtensions::Resource

  def pref_label
    Array(self[Solrizer.solr_name('pref_label', :stored_searchable)]).first
  end

  def citi_uid
    Array(self[Solrizer.solr_name('citi_uid', :symbol)]).first
  end

  def status
    Array(self[Solrizer.solr_name('status', :stored_searchable)]).first
  end

  def fedora_uri
    Array(self[Solrizer.solr_name('fedora_uri', :symbol)]).first
  end

  def aic_depositor
    Array(self[Solrizer.solr_name('aic_depositor', :symbol)]).first
  end

  def dept_created
    Array(self[Solrizer.solr_name('dept_created', :stored_searchable)]).first
  end

  # Date/Time resource was modified in Fedora
  def modified_date
    date_field('system_modified')
  end

  def document_ids
    Array(self[Solrizer.solr_name('documents', :symbol)])
  end

  def representation_ids
    Array(self[Solrizer.solr_name('representations', :symbol)])
  end

  def preferred_representation_id
    Array(self[Solrizer.solr_name('preferred_representation', :symbol)]).first
  end

  def visibility
    @visibility ||= if read_groups.include? Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC
                      Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
                    elsif read_groups.include? Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED
                      Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
                    else
                      Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
                    end
  end

  # Overrides CurationConcerns::SolrDocumentBehavior
  def title_or_label
    pref_label
  end
end
