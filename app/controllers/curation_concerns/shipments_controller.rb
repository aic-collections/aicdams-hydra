# frozen_string_literal: true
class CurationConcerns::ShipmentsController < ApplicationController
  include CurationConcerns::CurationConcernController
  include CitiResourceBehavior
  self.curation_concern_type = Shipment
  self.show_presenter = ShipmentPresenter
end
