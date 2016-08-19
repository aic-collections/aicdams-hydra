# frozen_string_literal: true
module CurationConcerns
  class FileSetsController < ApplicationController
    include CurationConcerns::FileSetsControllerBehavior
    include Sufia::Controller
    include Sufia::FileSetsControllerBehavior

    self.show_presenter = ::FileSetPresenter
  end
end
