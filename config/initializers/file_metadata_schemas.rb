# frozen_string_literal: true
# Adds the Fedora predicates for date created and modified to ActiveFedora's file metadata schemas.
# This is due to https://github.com/projecthydra/active_fedora/issues/1220 which, if fixed, will make this
# initializer file unnecessary.
class AdditionalFcrepoSchema < ActiveTriples::Schema
  property :fcrepo_create, predicate: ::RDF::Vocab::Fcrepo4.created
  property :fcrepo_modified, predicate: ::RDF::Vocab::Fcrepo4.lastModified
end

ActiveFedora::WithMetadata::DefaultMetadataClassFactory.file_metadata_schemas += [AdditionalFcrepoSchema]
