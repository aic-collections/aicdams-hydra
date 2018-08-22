# frozen_string_literal: true
module Lakeshore
  class FileSetsController < APIController
    def update
      file_sets_controller = CurationConcerns::FileSetsController.new
      file_sets_controller.request = request
      file_sets_controller.response = response

      # does callbacks https://stackoverflow.com/questions/5767222/rails-call-another-controller-action-from-a-controller/30143216#comment74479993_30143216
      file_sets_controller.process(:update)
      head file_sets_controller.response.code
    end

    def create
      file_sets_controller = CurationConcerns::FileSetsController.new
      file_sets_controller.request = request
      file_sets_controller.response = response

      file_sets_controller.send("curation_concern=", file_set_type)

      # does callbacks https://stackoverflow.com/questions/5767222/rails-call-another-controller-action-from-a-controller/30143216#comment74479993_30143216
      file_sets_controller.process(:create)
      head file_sets_controller.response.code
    end

    def create_or_update
      asset_uuid = params[:asset_uuid]
      asset = GenericWork.find asset_uuid
      file_set_role = params[:file_set_role]
      method = "#{file_set_role}_file_set"
      file_set = asset.send(method)&.first

      if file_set
        request.params[:id] = file_set.id
        update
      else
        request.params[:parent_id] = asset.id
        create
      end
    end

    private

      def uri_for_role
        { intermediate: AICType.IntermediateFileSet,
          preservation_master: AICType.PreservationMasterFileSet,
          original: AICType.OriginalFileSet,
          legacy: AICType.LegacyFileSet }
      end

      def file_set_type
        use_uri = uri_for_role[params[:file_set_role].to_sym]
        return FileSet.new if use_uri.nil?
        FileSet.new.tap do |fs|
          fs.type << use_uri
        end
      end
  end
end
