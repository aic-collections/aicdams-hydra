# frozen_string_literal: true
module BasicMetadata
  extend ActiveSupport::Concern

  class_methods do
    # Searches a resource's pref_label for an exact match
    # @param [String] label
    # @return [Class, nil]
    def find_by_label(label)
      where(Solrizer.solr_name("pref_label", :symbol).to_sym => label).first
    end

    def find_by_uid(uid)
      where(Solrizer.solr_name("uid", :symbol).to_sym => uid).first
    end
  end

  included do
    property :description, predicate: ::RDF::Vocab::DC11.description do |index|
      index.as :stored_searchable
    end

    property :pref_label, predicate: ::RDF::Vocab::SKOS.prefLabel, multiple: false do |index|
      index.as :stored_searchable, :symbol
    end

    property :uid, predicate: AIC.uid, multiple: false do |index|
      index.as :symbol, :stored_searchable
    end
  end
end
