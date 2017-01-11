# frozen_string_literal: true
module Lakeshore
  class IngestController < APIController
    # TODO
    # load_and_authorize_resource :curation_concern, class: 'GenericWork'

    delegate :intermediate_file, :asset_type, :ingestor, :attributes_for_actor, to: :ingest
    before_action :validate_ingest, :validate_asset_type, :validate_duplicate_upload

    def create
      if actor.create(attributes_for_actor)
        head :accepted
      else
        render_json_response(response_type: :unprocessable_entity, options: { errors: curation_concern.errors })
      end
    end

    protected

      def validate_ingest
        return if ingest.valid?
        render json: ingest.errors.full_messages, status: :bad_request
      end

      def validate_asset_type
        return if AssetTypeVerificationService.call(intermediate_file, asset_type)
        ingest.errors.add(:intermediate_file, "is not the correct asset type")
        render json: ingest.errors.full_messages, status: :bad_request
      end

      def validate_duplicate_upload
        return if duplicate_upload.empty?
        ingest.errors.add(:intermediate_file, "is a duplicate of #{duplicate_upload.first}")
        render json: ingest.errors.full_messages, status: :conflict
      end

    private

      def ingest
        @ingest ||= Lakeshore::Ingest.new(params)
      end

      def actor
        @actor ||= CurationConcerns::CurationConcern.actor(curation_concern, ingestor)
      end

      def curation_concern
        @curation_concern ||= GenericWork.new
      end

      def duplicate_upload
        @duplicate_upload ||= DuplicateUploadVerificationService.new(intermediate_file).duplicates
      end
  end
end
