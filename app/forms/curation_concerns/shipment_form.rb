# frozen_string_literal: true
# Generated via
#  `rails generate curation_concerns:work Shipment`
module CurationConcerns
  class ShipmentForm < CurationConcerns::Forms::WorkForm
    self.model_class = ::Shipment
    include CitiFormBehaviors
  end
end
