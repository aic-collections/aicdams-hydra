# frozen_string_literal: true
class CurationConcerns::PlacesController < ApplicationController
  include CurationConcerns::CurationConcernController
  include CitiResourceBehavior
  self.curation_concern_type = Place
  self.show_presenter = PlacePresenter
end
