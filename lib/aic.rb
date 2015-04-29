class AIC < RDF::StrictVocabulary("http://definitions.artic.edu/ontology/1.0/")

  term :after
  term :afterYear,
    label: "After Year".freeze
  term :artistUid,
    label: "Artist ID".freeze
  term :batchUid,
    label: "Batch UID".freeze,
    comment: "UID of batch process that ingested the resource".freeze
  term :before
  term :beforeYear,
    label: "Before Year".freeze
  term :birthDate,
    label: "Birth Date".freeze,
    comment: "Birth date".freeze
  term :birthPlace,
    label: "Birth Place".freeze,
    comment: "Birth place. ".freeze
  term :birthYear,
    label: "Birth Year".freeze,
    comment: "Birth year".freeze
  term :category
  term :citiUid,
    label: "CITI UID (PKey)".freeze,
    comment: "PKey from CITI table".freeze
  term :collCatUid,
    label: "Collection Category ID".freeze
  term :content,
    comment: "Annotation content".freeze
  term :created,
    label: "Created (external)".freeze,
    comment: "Creation timestamp for resources not managed by Hydra".freeze
  term :creatorUid,
    label: "Creator ID".freeze
  term :creditLine,
    label: "Credit Line".freeze
  term :deathDate,
    label: "Death Date".freeze,
    comment: "Death date".freeze
  term :deathPlace,
    label: "Death Place".freeze,
    comment: "Birth place".freeze
  term :deathYear,
    label: "Death Year".freeze,
    comment: "Death year".freeze
  term :deptCreated,
    label: "Created by Department".freeze,
    comment: "Department of resource creator".freeze
  term :deptUid,
    label: "Department ID".freeze
  term :deptUid,
    label: "CITI Department ID".freeze,
    comment: "Department ID from CITI".freeze
  term :dimensionsDisplay,
    label: "Dimensions Display".freeze
  term :endDate,
    label: "End Date".freeze,
    comment: "End date".freeze
  term :exhibitionHistory,
    label: "Exhibition History".freeze
  term :firstName,
    label: "First Name".freeze,
    comment: "First name".freeze
  term :galleryLocation,
    label: "Gallery Location".freeze
  term :geoLocX,
    label: "X Coordinate".freeze,
    comment: "X coordinate".freeze
  term :geoLocY,
    label: "Y Coordinate".freeze,
    comment: "Y coordinate".freeze
  term :hasComment,
    label: "Comment".freeze,
    comment: "Comment".freeze
  term :hasConstituent,
    label: "Has Constituent".freeze,
    comment: "Asset that is a constituent part of a Work rather than a representation or a document, e.g. an A/V stream that makes up a video artwork".freeze
  term :hasDocument,
    label: "Has Document".freeze,
    comment: "Asset documenting the resource".freeze
  term :hasDocument,
    label: "Has Document".freeze,
    comment: "URI of document".freeze
  term :hasInstance,
    label: "Instance".freeze,
    comment: "Asset instance URI".freeze
  term :hasLocation,    label: "Location".freeze,
   comment: "Location related to the resource".freeze
  term :hasMetadata,
    label: "Metadata".freeze,
    comment: "Metadata set related to the resource".freeze
  term :hasOriginalInstance,
    label: "Original Instance".freeze,
    comment: "Original instance URI".freeze
  term :hasPrefRepresentation,
    label: "Has Preferred Representation".freeze,
    comment: "Asset URI. This is the asset used to generate the thumbnail for the resource".freeze
  term :hasPublishingContext,
    label: "Publishing Context".freeze,
    comment: "Context that the resource is published in".freeze
  term :hasRepresentation,
    label: "Has Representation".freeze,
    comment: "Asset representing the resource".freeze
  term :hasRepresentation,
    label: "Has Representation".freeze,
    comment: "Asset URI".freeze
  term :hasRole,
    label: "Role".freeze,
    comment: "Location role".freeze
  term :hasRole,
    label: "Role".freeze,
    comment: "Character role".freeze
  term :hasTag,
    label: "Tag".freeze,
    comment: "Tag attached to the resource".freeze
  term :inscriptions,
    label: "Inscriptions".freeze
  term :isDerivedFrom,
    label: "Derived From".freeze,
    comment: "Source instance for the derivative".freeze
  term :lastName,
    label: "Last Name".freeze,
    comment: "Last name".freeze
  term :legacyUid,
    label: "Has Preferred Representation".freeze,
    comment: "UID assigned to resource from a legacy system".freeze
  term :mainRefNumber,
    label: "Main Reference Number".freeze
  term :medium,
    label: "Medium Display".freeze
  term :objectType,
    label: "Object Type".freeze
  term :originalFileName,
    label: "Original file name".freeze
  term :placeOfOrigin,
    label: "Place of Origin".freeze
  term :playsAs,
    label: "As Character".freeze,
    comment: "Character that the actor plays a role as".freeze
  term :playsAs,
    label: "As Location".freeze,
    comment: "Location that the place plays a role as".freeze
  term :provenanceText,
    label: "Provenance Text".freeze
  term :pubCatUid,
    label: "Publish Category ID".freeze
  term :publTag,
    label: "Publishing Tag".freeze
  term :publVerLevel,
    label: "Publish Verification Level".freeze
  term :publicationHistory,
    label: "Publication History".freeze
  term :startDate,
    label: "Start Date".freeze,
    comment: "Start date".freeze
  term :status,
    comment: "Status URI".freeze
  term :uid,
    label: "UID".freeze,
    comment: "Primary ID of resource. This is generated by UIDminter".freeze
  term :updated,
    label: "Updated (external)".freeze,
    comment: "Update timestamp for resources not managed by Hydra".freeze

end
