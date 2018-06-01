# frozen_string_literal: true
module Lakeshore
  class FileSetsController < APIController
    def update
      file_sets_controller = CurationConcerns::FileSetsController.new
      file_sets_controller.request = request
      file_sets_controller.response = response
      begin
        # does callbacks https://stackoverflow.com/questions/5767222/rails-call-another-controller-action-from-a-controller/30143216#comment74479993_30143216
        file_sets_controller.process(:update)
      rescue Permissions::WithAICDepositor::AICUserNotFound => e
        render plain: e.message, status: 500
      else
        head file_sets_controller.response.code
      end
    end
  end
end
