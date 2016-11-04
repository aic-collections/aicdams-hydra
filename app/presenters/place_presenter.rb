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
    Place.human_readable_type
  end

  include CitiPresenterBehaviors
  include ResourcePresenterBehaviors
end
