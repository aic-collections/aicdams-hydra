# frozen_string_literal: true
class AgentPresenter < Sufia::WorkShowPresenter
  def self.terms
    [
      :birth_date,
      :birth_year,
      :agent_type,
      :death_date,
      :death_year
    ] + CitiResourceTerms.all
  end

  def alt_display_label
    "Artist"
  end

  include CitiPresenterBehaviors
  include ResourcePresenterBehaviors
end
