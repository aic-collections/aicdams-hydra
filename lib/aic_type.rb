# frozen_string_literal: true
class AICType < RDF::StrictVocabulary("http://definitions.artic.edu/ontology/1.0/type/")
  term :Agent,
       subClassOf: "aictype:CitiResource",
       label: "Actor",
       comment: "A person, group of people or corporate body involved in some way in the lifecycle of a physical or digital resource."
  term :AICUser,
       subClassOf: "aictype:CitiResource",
       label: "AIC User",
       comment: "AIC User"
  term :Annotation,
       subClassOf: "aictype:Resource",
       label: "Annotation",
       comment: "Annotation"
  term :Archive,
       subClassOf: "aictype:Asset",
       label: "Archive",
       comment: "Archive"
  term :Asset,
       subClassOf: "aictype:Resource",
       label: "Asset"
  term :CitiResource,
       subClassOf: "aictype:Resource",
       label: "CITI Resource",
       comment: "Resource imported from CITI"
  term :Comment,
       subClassOf: "aictype:Annotation",
       label: "Comment",
       comment: "Comment"
  term :CommentCategory,
       subClassOf: "aictype:ListItem",
       label: "Comment category",
       comment: "Comment category"
  term :CompositingType,
       subClassOf: "aictype:ListItem",
       label: "Compositing",
       comment: "Compositing type"
  term :ConservationDocumentType,
       subClassOf: "aictype:ListItem",
       label: "Conservation document type",
       comment: "Conservation document type"
  term :ConservationImageType,
       subClassOf: "aictype:ListItem",
       label: "Conservation image type",
       comment: "Conservation image type"
  term :ConservationMetadata,
       subClassOf: "aictype:MetadataSet",
       label: "Conservation Metadata",
       comment: "Conservation metadata"
  term :Dataset,
       subClassOf: "aictype:Asset",
       label: "Dataset",
       comment: "Dataset"
  term :Department,
       subClassOf: "aictype:ListItem",
       label: "Department",
       comment: "Department"
  term :DigitizationSource,
       subClassOf: "aictype:ListItem",
       label: "Digitization source",
       comment: "Digitization source"
  term :DocumentType,
       subClassOf: "aictype:ListItem",
       label: "Document type",
       comment: "Document type"
  term :Exhibition,
       subClassOf: "aictype:CitiResource",
       label: "Exhibition",
       comment: "CITI Exhibition"
  term :IntermediateFileSet,
       subClassOf: Hydra::Works::Vocab::WorksTerms.FileSet,
       label: "Intermediate File Set",
       comment: "Intermediate file set"
  term :LightType,
       subClassOf: "aictype:ListItem",
       label: "Light type",
       comment: "Light type"
  term :List,
       subClassOf: "aictype:Resource",
       label: "List",
       comment: "List of options"
  term :ListItem,
       subClassOf: "aictype:Resource",
       label: "List Item",
       comment: "Item (option) in a list"
  term :MovingImage,
       subClassOf: "aictype:Asset",
       label: "Moving Image",
       comment: "Moving image"
  term :OriginalFileSet,
       subClassOf: Hydra::Works::Vocab::WorksTerms.FileSet,
       label: "Original File Set",
       comment: "Original file set"
  term :Place,
       subClassOf: "aictype:CitiResource",
       label: "Place",
       comment: "Place"
  term :PreservationMasterFileSet,
       subClassOf: Hydra::Works::Vocab::WorksTerms.FileSet,
       label: "Preservation File Set",
       comment: "Preservation file set"
  term :Resource,
       label: "Resource",
       comment: "LAKE base resource"
  term :Shipment,
       subClassOf: "aictype:CitiResource",
       label: "Shipment",
       comment: "CITI Shipment"
  term :Sound,
       subClassOf: "aictype:Asset",
       label: "Sound",
       comment: "Sound"
  term :StatusType,
       subClassOf: "aictype:ListItem",
       label: "Status",
       comment: "The status of a resource"
  term :StillImage,
       subClassOf: "aictype:Asset",
       label: "Still Image",
       comment: "Still image"
  term :Tag,
       subClassOf: "aictype:ListItem",
       label: "Tag",
       comment: "Tag"
  term :Text,
       subClassOf: "aictype:Asset",
       label: "Text Document",
       comment: "Text document"
  term :Transaction,
       subClassOf: "aictype:CitiResource",
       label: "Transaction",
       comment: "CITI Transaction"
  term :ViewType,
       subClassOf: "aictype:ListItem",
       label: "View Type",
       comment: "View type"
  term :Work,
       subClassOf: "aictype:CitiResource",
       label: "Work",
       comment: "CITI Object"
end
