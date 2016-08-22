# frozen_string_literal: true
class CurationConcerns::WorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  include CitiResourceBehavior
  self.curation_concern_type = Work
  self.show_presenter = WorkPresenter
end
