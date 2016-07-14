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

  include CitiPresenterBehaviors

  def deleteable?
    current_ability.can?(:delete, Agent)
  end
end
