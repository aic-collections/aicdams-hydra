# frozen_string_literal: true
module Lakeshore
  class FileSetsController < APIController

    before_action :validate_depositor

    def update
      file_sets_controller = CurationConcerns::FileSetsController.new
      file_sets_controller.request = request
      file_sets_controller.response = response

      # does callbacks https://stackoverflow.com/questions/5767222/rails-call-another-controller-action-from-a-controller/30143216#comment74479993_30143216
      file_sets_controller.process(:update)

      head file_sets_controller.response.code
    end
  end
end
