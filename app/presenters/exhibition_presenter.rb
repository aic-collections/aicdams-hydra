# frozen_string_literal: true
class ExhibitionPresenter < Sufia::WorkShowPresenter
  def self.terms
    [
      :start_date,
      :end_date,
      :name_official,
      :name_working,
      :exhibition_type
    ] + CitiResourceTerms.all
  end

  include CitiPresenterBehaviors
  include ResourcePresenterBehaviors
end
