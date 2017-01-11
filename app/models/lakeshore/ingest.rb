# frozen_string_literal: true
module Lakeshore
  class Ingest
    include ActiveModel::Validations

    attr_reader :ingestor, :submitted_asset_type, :document_type_uri, :original_file,
                :intermediate_file, :presevation_master_file, :additional_files, :params

    validates :ingestor, :asset_type, :document_type_uri, :intermediate_file, presence: true

    # @param [ActionController::Parameters] params from the controller
    def initialize(params)
      @params = params
      @submitted_asset_type = params.fetch(:asset_type)
      register_files(params.fetch(:content, {}))
      register_terms(params.fetch(:metadata, {}))
    end

    def asset_type
      return AICType.send(submitted_asset_type) if AICType.respond_to?(submitted_asset_type)
      errors.add(:asset_type, "#{submitted_asset_type} is not a registered asset type")
    end

    # @return [Array<FileSet>]
    # Order is important. The representative file set is the first one added to the work. We
    # want the intermediate file to be the representative.
    def files
      return [] unless valid?
      [intermediate_upload, original_upload, presevation_master_upload].compact + additional_uploads
    end

    def attributes_for_actor
      attributes = CurationConcerns::GenericWorkForm.model_attributes(params.fetch("metadata"))
      attributes[:uploaded_files] = files
      attributes[:permissions_attributes] = JSON.parse(params.fetch(:sharing, "[]"))
      attributes.merge!(asset_type: asset_type)
    end

    private

      def register_terms(metadata)
        return unless metadata.present?
        @document_type_uri = metadata.fetch(:document_type_uri, nil)
        @ingestor = find_or_create_user(metadata.fetch(:depositor, nil))
      end

      def find_or_create_user(key)
        return unless key
        User.find_by_user_key(key) || User.create!(email: key)
      end

      def register_files(content)
        return unless content.present?
        @original_file = content.delete(:original)
        @intermediate_file = content.delete(:intermediate)
        @presevation_master_file = content.delete(:pres_master)
        @additional_files = content
      end

      def original_upload
        return unless original_file
        Sufia::UploadedFile.create(file: original_file,
                                   user: ingestor,
                                   use_uri: AICType.OriginalFileSet).id.to_s
      end

      def intermediate_upload
        return unless intermediate_file
        Sufia::UploadedFile.create(file: intermediate_file,
                                   user: ingestor,
                                   use_uri: AICType.IntermediateFileSet).id.to_s
      end

      def presevation_master_upload
        return unless presevation_master_file
        Sufia::UploadedFile.create(file: presevation_master_file,
                                   user: ingestor,
                                   use_uri: AICType.PreservationMasterFileSet).id.to_s
      end

      def additional_uploads
        additional_files.values.map do |file|
          Sufia::UploadedFile.create(file: file, user: ingestor)
        end
      end
  end
end
