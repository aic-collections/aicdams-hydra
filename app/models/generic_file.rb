class GenericFile < ActiveFedora::Base

  include Sufia::GenericFile

  type AICType.Resource

  property :aic_type, predicate: ::RDF::DC.type do |index|
    index.as :stored_searchable
  end
  property :coverage, predicate: ::RDF::DC.coverage do |index|
    index.as :stored_searchable
  end
  property :date, predicate: ::RDF::DC.date do |index|
    index.as :stored_searchable
  end
  property :format, predicate: ::RDF::DC.format do |index|
    index.as :stored_searchable
  end
  property :relation, predicate: ::RDF::DC.relation do |index|
    index.as :stored_searchable
  end
  property :pref_label, predicate: ::RDF::SKOS.prefLabel do |index|
    index.as :stored_searchable
  end  
  property :batch_uid, predicate: AIC.batchUid do |index|
    index.as :stored_searchable
  end 
  property :dept_created, predicate: AIC.deptCreated do |index|
    index.as :stored_searchable
  end 
  property :has_location, predicate: AIC.hasLocation do |index|
    index.as :stored_searchable
  end 
  property :has_metadata, predicate: AIC.hasMetadata do |index|
    index.as :stored_searchable
  end 
  property :has_publishing_context, predicate: AIC.hasPublishingContext do |index|
    index.as :stored_searchable
  end 
  property :uid, predicate: AIC.uid do |index|
    index.as :stored_searchable
  end 
  
  has_and_belongs_to_many :comments, predicate: AIC.hasComment, class_name: "Comment", inverse_of: :generic_files
  has_and_belongs_to_many :tags, predicate: AIC.hasTag, class_name: "Tag", inverse_of: :generic_files
  accepts_nested_attributes_for :comments, :tags

end
