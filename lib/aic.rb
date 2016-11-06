# frozen_string_literal: true
class AIC < RDF::StrictVocabulary("http://definitions.artic.edu/ontology/1.0/")
  term :ActiveStaff,
       label: "Active Staff",
       comment: "Active staff."
  term :ActiveUser,
       label: "Active User",
       comment: "Active user."
  term :agentType,
       label: "Agent Type",
       comment: "Type of agent: individual person, group, corporate entity"
  term :artist,
       label: "Artist",
       comment: "Artist"
  term :batchUid,
       label: "Batch UID",
       comment: "UID of batch process that ingested the resource"
  term :birthDate,
       label: "Birth Date",
       comment: "Birth date"
  term :birthYear,
       label: "Birth Year",
       comment: "Birth year"
  term :captureDevice,
       label: "Capture Device",
       comment: "Capture device of original file"
  term :category,
       label: "Category",
       comment: "Comment category"
  term :citiIcon,
       label: "CITI Icon",
       comment: "URI of special icon for CITI"
  term :citiUid,
       label: "CITI UID",
       comment: "CITI unique identifier (PKey)"
  term :compositing,
       label: "Compositing",
       comment: "Compositing type"
  term :conservationDocType,
       label: "Conservation Document Type",
       comment: "Document type used by Conservation"
  term :content,
       label: "Content",
       comment: "Annotation content"
  term :contributor,
       label: "Contributor",
       comment: "Person or corporate body who participated in the creation of the resource"
  term :created,
       label: "Created On",
       comment: "Creation timestamp for resources not managed by Hydra"
  term :createdBy,
       label: "Created By",
       comment: "Person or corporate body who was primarily responsible for the creation of the resource"
  term :creatorDisplay,
       label: "Creator",
       comment: "Creator of the work (display)"
  term :creditLine,
       label: "Credit Line",
       comment: "Credit line"
  term :currentLocation,
       label: "Current Location",
       comment: "Current Location"
  term :dateDisplay,
       label: "Date (display)",
       comment: "Collocation date(s)"
  term :deathDate,
       label: "Death Date",
       comment: "Death date"
  term :deathYear,
       label: "Death Year",
       comment: "Death year"
  term :department,
       label: "Department",
       comment: "AIC department"
  term :deptCreated,
       label: "Created by Department",
       comment: "Department of resource creator"
  term :digitizationSource,
       label: "Digitization source",
       comment: "Original document for non-born-digital assets"
  term :dimensionsDisplay,
       label: "Dimensions Display",
       comment: "Display dimensions"
  term :documentType,
       label: "Document Type",
       comment: "Select one document type from the hierarchy"
  term :documentSubType1,
       label: "Document Sub-Type 1",
       comment: "Select one document sub-type from the hierarchy"
  term :documentSubType2,
       label: "Document Sub-Type 2",
       comment: "Select one document sub-type from the hierarchy"
  term :earliestDate,
       label: "Earliest Date",
       comment: "Earliest preferred date"
  term :earliestYear,
       label: "Earliest Year",
       comment: "Earliest preferred year"
  term :endDate,
       label: "End Date",
       comment: "End date"
  term :exhibition,
       label: "Exhibition",
       comment: "Related exhibition"
  term :exhibitionHistory,
       label: "Exhibition History",
       comment: "Exhibition history text"
  term :galleryLocation,
       label: "Gallery Location",
       comment: "Gallery location"
  term :hasComment,
       label: "Comment",
       comment: "Comment"
  term :hasConstituent,
       label: "Has Constituent",
       comment: "Asset that is a constituent part of a Work rather than a representation or a document, e.g. an A/V stream that makes up a video artwork"
  term :hasDocument,
       label: "Has Document",
       comment: "Asset documenting the resource"
  term :hasPreferredRepresentation,
       label: "Has Preferred Image",
       comment: "Asset that is a primary representation of the Resource. This asset is used to create the thumbnail for non-Asset resources"
  term :hasRepresentation,
       label: "Has Representation",
       comment: "Asset representing (depicting) the resource"
  term :icon,
       label: "Icon",
       comment: "URI of thumbnail or icon representing the resource"
  term :imagingUid,
       label: "Image Number",
       comment: "Unique image number assigned by Imaging."
  term :inscriptions,
       label: "Inscriptions",
       comment: "Inscriptions on object"
  term :keyword,
       label: "Keyword",
       comment: "Keyword to loosely classify a resource by topic, theme, subject, etc."
  term :latestDate,
       label: "Latest Date",
       comment: "Latest preferred date"
  term :latestYear,
       label: "Latest Year",
       comment: "Latest preferred year"
  term :legacyUid,
       label: "Legacy ID",
       comment: "UID assigned to resource from a legacy system"
  term :lightType,
       label: "Light Type",
       comment: "Light type used to capture the image"
  term :locationType,
       label: "Location Type",
       comment: "Location type"
  term :mainRefNumber,
       label: "Main Reference Number",
       comment: "Main reference number"
  term :mediumDisplay,
       label: "Medium Display",
       comment: "Display medium"
  term :nameOfficial,
       label: "Official Name",
       comment: "Official name"
  term :nameWorking,
       label: "Working Name",
       comment: "Working name"
  term :objectType,
       label: "Object Type",
       comment: "Object type"
  term :placeOfOrigin,
       label: "Place of Origin",
       comment: "Place of origin"
  term :provenanceText,
       label: "Provenance Text",
       comment: "Provenance text"
  term :publicationHistory,
       label: "Publication History",
       comment: "Publication history text"
  term :publVerLevel,
       label: "Publish Verification Level",
       comment: "Publish verification level"
  term :specialImageType,
       label: "Special Image Type",
       comment: "Technical image type"
  term :startDate,
       label: "Start Date",
       comment: "Start date"
  term :status,
       label: "Status",
       comment: "Status of the resource"
  term :transcript,
       label: "Transcript",
       comment: "Plain-text transcription, either manually or automatically extracted from the document"
  term :exhibitionType,
       label: "Type ID",
       comment: "Type (ID) of exhibition"
  term :uid,
       label: "UID",
       comment: "Primary ID of resource. This is generated by UIDminter"
  term :updated,
       label: "Updated On",
       comment: "Update timestamp for resources not managed by Hydra"
  term :view,
       label: "View",
       comment: "Viewing angle, overall or detail, etc"
end
