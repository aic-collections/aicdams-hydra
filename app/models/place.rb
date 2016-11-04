# frozen_string_literal: true
class Place < CitiResource
  include ::CurationConcerns::WorkBehavior
  include CitiBehaviors

  self.human_readable_type = "Current Location"

  def self.aic_type
    super << AICType.Place
  end

  type type + aic_type

  property :location_type, predicate: AIC.locationType, multiple: false, class_name: "ActiveFedora::Base"

  property :lat, predicate: ::RDF::Vocab::GEO.lat, multiple: false do |index|
    index.as :symbol
  end

  property :long, predicate: ::RDF::Vocab::GEO.long, multiple: false do |index|
    index.as :symbol
  end
end
