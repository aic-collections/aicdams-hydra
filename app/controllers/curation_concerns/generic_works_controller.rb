# frozen_string_literal: true
class CurationConcerns::GenericWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  include Sufia::WorksControllerBehavior
  include CitiResourceBehavior
  self.curation_concern_type = GenericWork
  self.show_presenter = AssetPresenter

  protected

    def search_builder_class
      AssetSearchBuilder
    end
end
