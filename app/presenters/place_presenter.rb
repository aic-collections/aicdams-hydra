# frozen_string_literal: true
class PlacePresenter < Sufia::WorkShowPresenter
  def self.terms
    [
      :location_type,
      :lat,
      :long
    ] + CitiResourceTerms.all
  end

  def alt_display_label
    "Current Location"
  end

  include CitiPresenterBehaviors
  include ResourcePresenterBehaviors
end
