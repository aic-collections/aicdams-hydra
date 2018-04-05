# frozen_string_literal: true
module Lakeshore
  class Ingest
    include ActiveModel::Validations

    attr_reader :ingestor, :submitted_asset_type, :document_type_uri, :original_file,
                :intermediate_file, :presevation_master_file, :legacy_file, :additional_files, :params,
                :preferred_representation_for, :force_preferred_representation

    validates :ingestor, :asset_type, :document_type_uri, :intermediate_file, presence: true

    # @param [ActionController::Parameters] params from the controller
    def initialize(params)
      @params = params
      @submitted_asset_type = params.fetch(:asset_type, nil)
      register_files(params.fetch(:content, {}))
      register_terms(params.fetch(:metadata, {}))
    end

    def asset_type
      return unless submitted_asset_type
      return AICType.send(submitted_asset_type) if AICType.respond_to?(submitted_asset_type)
      errors.add(:asset_type, "#{submitted_asset_type} is not a registered asset type")
    end

    # @return [Array<FileSet>]
    # Order is important. The representative file set is the first one added to the work. We
    # want the intermediate file to be the representative.
    def files
      return [] unless valid? || valid_update?
      [intermediate_upload, original_upload, presevation_master_upload, legacy_upload].compact + additional_uploads
    end

    def attributes_for_actor
      attributes = CurationConcerns::GenericWorkForm.model_attributes(params.fetch("metadata"))
      attributes[:uploaded_files] = files
      attributes[:permissions_attributes] = permitted_permissions
      attributes.merge!(asset_type: asset_type, ingest_method: "api")
    end

    # TODO: We ought to be able to use features of ActiveModel::Validations instead of this custom method
    def valid_update?
      ingestor.present?
    end

    # @return [Boolean]
    # Only returns false if the parameter is explicitly set to "false"
    def check_duplicates?
      params.fetch(:duplicate_check, nil) == "false" ? false : true
    end

    # @return [Array<String>]
    # Returns an array of ids from preferred_representation_for that already have preferred representations defined.
    def represented_resources
      preferred_representation_for.select do |id|
        SolrDocument.new(ActiveFedora::SolrService.query("id:#{id}").first).preferred_representation_id.present?
      end
    end

    def force_preferred_representation?
      return true if force_preferred_representation == "true" || force_preferred_representation == 1
      false
    end

    private

      def register_terms(metadata)
        return unless metadata.present?
        @document_type_uri = metadata.fetch(:document_type_uri, nil)
        @preferred_representation_for = metadata.fetch(:preferred_representation_for, [])
        @ingestor = find_or_create_user(metadata.fetch(:depositor, nil))
        @force_preferred_representation = metadata.fetch(:force_preferred_representation, false)
      end

      def find_or_create_user(key)
        return unless key
        return unless AICUser.find_by_nick(key).present?
        User.find_by_user_key(key) || User.create!(email: key)
      end

      def register_files(content)
        return unless content.present?
        @original_file = content.delete(:original)
        @intermediate_file = content.delete(:intermediate)
        @presevation_master_file = content.delete(:pres_master)
        @legacy_file = content.delete(:legacy)
        @additional_files = content
      end

      # @return [Array<Hash>]
      # Removes any additional permissions having to do with the depositor.
      # The depositor's permissions are fixed and are not allowed to be altered.
      def permitted_permissions
        JSON.parse(params.fetch(:sharing, "[]")).delete_if do |permission|
          permission.fetch("type", nil) == "person" && permission.fetch("name", nil) == ingestor.email
        end
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

      def legacy_upload
        return unless legacy_file
        Sufia::UploadedFile.create(file: legacy_file,
                                   user: ingestor,
                                   use_uri: AICType.LegacyFileSet).id.to_s
      end

      def additional_uploads
        return [] unless additional_files
        additional_files.values.map do |file|
          Sufia::UploadedFile.create(file: file, user: ingestor)
        end
      end
  end
end
