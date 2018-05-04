# frozen_string_literal: true
module Lakeshore
  class Ingest
    include ActiveModel::Validations

    attr_reader :ingestor, :submitted_asset_type, :document_type_uri, :params,
                :preferred_representation_for, :force_preferred_representation, :registry

    validates :ingestor, :asset_type, :document_type_uri, :intermediate_file, presence: true

    delegate :intermediate_file, :duplicate_error, to: :registry

    # @param [ActionController::Parameters] params from the controller
    def initialize(params)
      @params = params
      @submitted_asset_type = params.fetch(:asset_type, nil)
      register_terms(params.fetch(:metadata, {}))
      @registry = IngestRegistry.new(params.fetch(:content, {}), ingestor)
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
      registry.upload_ids
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

    # @return [true, false]
    # Only returns true if the parameter is explicitly set to "false"
    def check_duplicates_turned_off?
      params.fetch(:duplicate_check, nil) == "false"
    end

    # @return [true, false]
    # If the ingest is not unique, then errors should be reported
    def unique?
      (check_duplicates_turned_off? || intermediate_file.nil? || registry.unique?)
    end

    # @return [Array<String>]
    # Returns an array of ids from preferred_representation_for that already have preferred representations defined.
    def represented_resources
      preferred_representation_for.select do |id|
        SolrDocument.new(ActiveFedora::SolrService.query("id:#{id}").first).preferred_representation_id.present?
      end
    end

    # @return [true, false]
    # Only returns true if the parameter is explicitly set to "true"
    def force_preferred_representation?
      params.fetch(:force_preferred_representation, nil) == "true"
    end

    private

      def register_terms(metadata)
        @document_type_uri = metadata.fetch(:document_type_uri, nil)
        @preferred_representation_for = metadata.fetch(:preferred_representation_for, [])
        @ingestor = find_or_create_user(metadata.fetch(:depositor, nil))
      end

      def find_or_create_user(key)
        return unless key
        return unless AICUser.find_by_nick(key).present?
        User.find_by_user_key(key) || User.create!(email: key)
      end

      # @return [Array<Hash>]
      # Removes any additional permissions having to do with the depositor.
      # The depositor's permissions are fixed and are not allowed to be altered.
      def permitted_permissions
        JSON.parse(params.fetch(:sharing, "[]")).delete_if do |permission|
          permission.fetch("type", nil) == "person" && permission.fetch("name", nil) == ingestor.email
        end
      end
  end
end
