# frozen_string_literal: true
class CurationConcerns::ExhibitionsController < ApplicationController
  include CurationConcerns::CurationConcernController
  include CitiResourceBehavior
  self.curation_concern_type = Exhibition
  self.show_presenter = ExhibitionPresenter
end
