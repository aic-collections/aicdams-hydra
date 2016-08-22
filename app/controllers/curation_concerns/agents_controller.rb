# frozen_string_literal: true
class CurationConcerns::AgentsController < ApplicationController
  include CurationConcerns::CurationConcernController
  include CitiResourceBehavior
  self.curation_concern_type = Agent
  self.show_presenter = AgentPresenter
end
