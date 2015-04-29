class AICType < RDF::StrictVocabulary("http://definitions.artic.edu/ontology/1.0/type/")

  term :Activity,
    subClassOf: "aictype:Event".freeze,
    comment: "Human activity".freeze
  term :Actor,
    subClassOf: "aictype:NonInformationResource".freeze
  term :ActorRole,
    subClassOf: "aictype:ListItem".freeze,
    label: "Actor Role".freeze,
    comment: "Actor role. ".freeze
  term :Annotation,
    subClassOf: "aictype:InformationResource".freeze
  term :Asset,
    subClassOf: "aictype:InformationResource".freeze
  term :Category,
    subClassOf: "aictype:ListItem".freeze,
    comment: "General category".freeze
  term :Character,
    subClassOf: "aictype:NonInformationResource".freeze,
    label: "AIC Department".freeze,
    comment: "A combination of an Actor and a Role in a specific context".freeze
  term :Comment,
    subClassOf: "aictype:Annotation".freeze
  term :Department,
    subClassOf: "aictype:NonInformationResource".freeze,
    label: "AIC Department".freeze,
    comment: "AIC Department".freeze
  term :DescriptiveMeta,
    subClassOf: "aictype:MetadataSet".freeze,
    label: "Descriptive Metadata".freeze
  term :Event,
    subClassOf: "aictype:NonInformationResource".freeze,
    comment: "Time-based event".freeze
  term :Exhibition,
    subClassOf: "aictype:Activity".freeze,
    comment: "CITI Exhibition".freeze
  term :ExifMeta,
    subClassOf: "aictype:TechMeta".freeze,
    label: "EXIF Metadata".freeze
  term :InformationResource,
    subClassOf: "aictype:Resource".freeze,
    label: "Information Resource".freeze,
    comment: "Information resource".freeze
  term :Instance,
    subClassOf: "fcrepo:Binary".freeze,
    comment: "Particular format of an Asset. It represents a binary file".freeze
  term :ListItem,
    subClassOf: "aictype:InformationResource".freeze,
    label: "List Item".freeze,
    comment: "Support list item".freeze
  term :Location,
    subClassOf: "aictype:NonInformationResource".freeze,
    comment: "A combination of a Place and a Role in a specific context".freeze
  term :MetadataSet,
    subClassOf: "aictype:InformationResource".freeze,
    label: "Metadata Set".freeze,
    comment: "Metadata set".freeze
  term :NonInformationResource,
    subClassOf: "aictype:Resource".freeze,
    label: "Non-Information Resource".freeze,
    comment: "A non-information Resource (most CITI entities)".freeze
  term :OriginalInstance,
    subClassOf: "aictype:Instance".freeze,
    label: "Original Instance".freeze,
    comment: "File as originally ingested into LAKE".freeze
  term :Place,
    subClassOf: "aictype:NonInformationResource".freeze,
    comment: "CITI Place".freeze
  term :PlaceRole,
    subClassOf: "aictype:ListItem".freeze,
    label: "Place Role".freeze,
    comment: "Place role. ".freeze
  term :Resource,
    subClassOf: "fcrepo:Resource".freeze,
    comment: "LAKE base resource".freeze
  term :Shipment,
    subClassOf: "aictype:Activity".freeze,
    comment: "CITI Shipment".freeze
  term :StillImage,
    subClassOf: "aictype:Image".freeze,
    label: "Still Image".freeze,
    comment: "Still image".freeze
  term :Tag,
    subClassOf: "aictype:Annotation".freeze
  term :TagCat,
    subClassOf: "aictype:Category".freeze,
    label: "Tag Category".freeze,
    comment: "Tag category".freeze
  term :TechMeta,
    subClassOf: "aictype:MetadataSet".freeze,
    label: "Technical Metadata".freeze
  term :Text,
    subClassOf: "aictype:Text".freeze,
    label: "Text Document".freeze,
    comment: "Textual asset".freeze
  term :Transaction,
    subClassOf: "aictype:Activity".freeze,
    comment: "CITI Transaction".freeze
  term :VraMeta,
    subClassOf: "aictype:DescriptiveMeta".freeze,
    label: "VRA Metadata".freeze
  term :Work,
    subClassOf: "aictype:NonInformationResource".freeze,
    comment: "CITI Object".freeze

end
