# frozen_string_literal: true
module ResourceMetadata
  extend ActiveSupport::Concern

  included do
    property :batch_uid, predicate: AIC.batchUid, multiple: false do |index|
      index.as :stored_searchable
    end

    # TODO: Is citiIcon needed? Can it be a pcdm:File?
    property :citi_icon, predicate: AIC.citiIcon, multiple: false, class_name: "ActiveFedora::Base"

    property :contributors, predicate: ::RDF::Vocab::DC.contributor, class_name: "Agent"

    property :created, predicate: AIC.created, multiple: false do |index|
      index.type :date
      index.as :stored_sortable
    end

    property :created_by, predicate: AIC.createdBy, multiple: false, class_name: "AICUser"

    property :documents, predicate: AIC.hasDocument, class_name: "GenericWork"

    property :preferred_representation, predicate: AIC.hasPreferredRepresentation, multiple: false, class_name: "GenericWork"

    property :representations, predicate: AIC.hasRepresentation, class_name: "GenericWork"

    # TODO: Can we use what CC uses?
    property :icon, predicate: AIC.icon, multiple: false, class_name: "ActiveFedora::Base"

    property :uid, predicate: AIC.uid, multiple: false do |index|
      index.as :symbol, :stored_searchable
    end

    property :updated, predicate: AIC.updated, multiple: false do |index|
      index.type :date
      index.as :stored_sortable
    end

    property :language, predicate: ::RDF::Vocab::DC11.language do |index|
      index.as :stored_searchable
    end

    property :publisher, predicate: ::RDF::Vocab::DC.publisher, class_name: "Agent"

    property :rights, predicate: ::RDF::Vocab::DC11.rights do |index|
      index.as :stored_searchable
    end

    # TODO: Needs to be aictype:Text
    property :rights_statement, predicate: ::RDF::Vocab::DC.rights, class_name: "ActiveFedora::Base"

    property :rights_holder, predicate: ::RDF::Vocab::DC.rightsHolder, class_name: "Agent"

    property :alt_label, predicate: ::RDF::Vocab::SKOS.altLabel do |index|
      index.as :stored_searchable, :symbol
    end

    accepts_uris_for :citi_icon, :contributors, :created_by, :documents, :preferred_representation, :representations,
                     :icon, :publisher, :rights_statement, :rights_holder
  end
end
