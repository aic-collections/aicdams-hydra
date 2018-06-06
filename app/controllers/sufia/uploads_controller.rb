# frozen_string_literal: true
module Sufia
  class UploadsController < ApplicationController
    load_and_authorize_resource class: UploadedFile
    before_action :validate_asset_type, only: [:create]

    def create
      @upload.attributes = { file: uploaded_file, user: current_user, use_uri: use_uri, uploaded_batch_id: uploaded_batch_id }

      if @upload.save
        render status: :ok
      else
        render json: { files: [@upload.errors.messages[:checksum].first] }
      end
    end

    def destroy
      @upload.destroy
      head :no_content
    end

    def update
      upload = Sufia::UploadedFile.find(params[:id])
      upload.use_uri = params[:use_uri]
      if upload.save
        head :accepted
      else
        head :unprocessable_entity
      end
    end

    private

      def validate_asset_type
        return if AssetTypeVerificationService.call(uploaded_file, asset_type)
        render json: { files: [error_message] }
      end

      def uploaded_file
        params[:files].first
      end

      def uploaded_batch_id
        asset_attributes.fetch(:uploaded_batch_id, nil)
      end

      def asset_type
        asset_attributes.fetch(:asset_type)
      end

      def use_uri
        asset_attributes.fetch(:use_uri, nil)
      end

      # AICType.find_term(asset_type).label ought to work here, but doesn't
      def type_label
        ::RDF::URI(asset_type).path.split("/").last.underscore.humanize.downcase
      end

      def error_message
        {
          error: t('lakeshore.upload.errors.invalid', name: uploaded_file.original_filename, type: type_label)
        }
      end

      # We use this controller with both the single upload and batch upload form
      # so it needs to work with both kinds of parameter hashes.
      def asset_attributes
        params.fetch(:generic_work, nil) || params.fetch(:batch_upload_item, nil)
      end
  end
end
