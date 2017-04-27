# frozen_string_literal: true
module Lakeshore
  class IngestController < APIController
    # TODO
    # load_and_authorize_resource :curation_concern, class: 'GenericWork'

    delegate :intermediate_file, :asset_type, :ingestor, :attributes_for_actor,
             :check_duplicates?, :represented_resources, to: :ingest

    before_action :validate_ingest, :validate_asset_type, only: [:create]
    before_action :validate_duplicate_upload, :validate_preferred_representations, only: [:create, :update]

    def create
      if actor.create(attributes_for_actor)
        head :accepted
      else
        render_json_response(response_type: :unprocessable_entity, options: { errors: curation_concern.errors })
      end
    end

    def update
      if actor.update(attributes_for_actor)
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
        return unless intermediate_file
        return if AssetTypeVerificationService.call(intermediate_file, asset_type)
        ingest.errors.add(:intermediate_file, "is not the correct asset type")
        render json: ingest.errors.full_messages, status: :bad_request
      end

      def validate_duplicate_upload
        return unless intermediate_file && check_duplicates?
        return if duplicate_upload.empty?
        ingest.errors.add(:intermediate_file, "is a duplicate of #{duplicate_upload.first}")
        render json: duplicate_error, status: :conflict
      end

      def validate_preferred_representations
        return unless represented_resources.present?
        ingest.errors.add(:represented_resources, "#{represented_resources.join(', ')} already have a preferred representation")
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
        @curation_concern ||= if params[:id]
                                GenericWork.find(params[:id])
                              else
                                GenericWork.new
                              end
      end

      def duplicate_upload
        @duplicate_upload ||= DuplicateUploadVerificationService.new(intermediate_file).duplicate_file_sets
      end

      def duplicate_error
        {
          message: "Duplicate detected.",
          uploaded_resource: {
            id: ingest.params["metadata"].fetch("uid", nil),
            file_name: intermediate_file.original_filename
          },
          stored_resource: {
            fileset_id: duplicate_upload.first.id,
            pref_label: duplicate_upload.first.parent.pref_label
          }
        }
      end
  end
end
