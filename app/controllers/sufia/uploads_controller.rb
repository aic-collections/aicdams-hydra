# frozen_string_literal: true
module Sufia
  class UploadsController < ApplicationController
    load_and_authorize_resource class: UploadedFile
    before_action :validate_asset_type, only: [:create]

    def create
      @upload.attributes = { file: uploaded_file, user: current_user }
      @upload.save!
    end

    def destroy
      @upload.destroy
      head :no_content
    end

    private

      def validate_asset_type
        return if AssetTypeVerificationService.call(uploaded_file, asset_type)
        render json: { files: [{ error: error_message }] }
      end

      def uploaded_file
        params[:files].first
      end

      def asset_type
        asset_attributes.fetch(:asset_type)
      end

      # AICType.find_term(asset_type).label ought to work here, but doesn't
      def type_label
        ::RDF::URI(asset_type).path.split("/").last.underscore.humanize.downcase
      end

      def error_message
        "Incorrect asset type. #{uploaded_file.original_filename} is not a type of #{type_label}"
      end

      # We use this controller with both the single upload and batch upload form
      # so it needs to work with both kinds of parameter hashes.
      def asset_attributes
        params.fetch(:generic_work, nil) || params.fetch(:batch_upload_item, nil)
      end
  end
end
