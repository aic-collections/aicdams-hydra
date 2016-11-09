# frozen_string_literal: true
class Work < CitiResource
  include ::CurationConcerns::WorkBehavior
  include CitiBehaviors
  include PrefLabel
  self.indexer = WorkIndexer

  def self.aic_type
    super << AICType.Work
  end

  type type + aic_type

  property :artist, predicate: AIC.artist, class_name: "Agent" do |index|
    index.as :stored_searchable, using: :pref_label
  end
  accepts_uris_for :artist

  property :current_location, predicate: AIC.currentLocation, class_name: "Place" do |index|
    index.as :stored_searchable, using: :pref_label
  end
  accepts_uris_for :current_location

  property :creator_display, predicate: AIC.creatorDisplay, multiple: false do |index|
    index.as :stored_searchable
  end

  property :credit_line, predicate: AIC.creditLine, multiple: false do |index|
    index.as :stored_searchable
  end

  property :date_display, predicate: AIC.dateDisplay, multiple: false do |index|
    index.as :stored_searchable
  end

  property :department, predicate: AIC.department, class_name: "Department" do |index|
    index.as :stored_searchable, using: :pref_label
  end
  accepts_uris_for :department

  property :dimensions_display, predicate: AIC.dimensionsDisplay do |index|
    index.as :stored_searchable
  end

  property :earliest_year, predicate: AIC.earliestYear, multiple: false do |index|
    index.as :stored_searchable
  end

  property :exhibition_history, predicate: AIC.exhibitionHistory, multiple: false do |index|
    index.as :stored_searchable
  end

  property :gallery_location, predicate: AIC.galleryLocation, multiple: false do |index|
    index.as :stored_searchable
  end

  property :inscriptions, predicate: AIC.inscriptions, multiple: false do |index|
    index.as :stored_searchable
  end

  property :latest_year, predicate: AIC.latestYear, multiple: false do |index|
    index.as :stored_searchable
  end

  property :main_ref_number, predicate: AIC.mainRefNumber, multiple: false do |index|
    index.as :stored_searchable
  end

  property :medium_display, predicate: AIC.mediumDisplay, multiple: false do |index|
    index.as :stored_searchable
  end

  property :object_type, predicate: AIC.objectType, multiple: false do |index|
    index.as :stored_searchable
  end

  property :place_of_origin, predicate: AIC.placeOfOrigin, multiple: false do |index|
    index.as :stored_searchable
  end

  property :provenance_text, predicate: AIC.provenanceText, multiple: false do |index|
    index.as :stored_searchable
  end

  property :publication_history, predicate: AIC.publicationHistory, multiple: false do |index|
    index.as :stored_searchable
  end

  property :publ_ver_level, predicate: AIC.publVerLevel, multiple: false do |index|
    index.as :stored_searchable
  end
end
