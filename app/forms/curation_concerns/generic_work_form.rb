# frozen_string_literal: true
module CurationConcerns
  class GenericWorkForm < Sufia::Forms::WorkForm
    include AssetFormBehaviors
    include PropertyPermissions

    delegate :dept_created, :attachment_uris, :attachments, :copyright_representatives, :imaging_uid_placeholder, to: :model

    attr_writer :action_name, :current_ability

    def self.aic_terms(action_name: nil, current_ability: nil)
      terms = [
        :asset_type, :document_type_uri, :imaging_uid_placeholder, :caption, :first_document_sub_type_uri, :second_document_sub_type_uri,
        :pref_label, :alt_label, :description, :language, :publisher, :capture_device,
        :status_uri, :digitization_source_uri, :compositing_uri, :light_type_uri, :view_uris,
        :keyword_uris, :publish_channel_uris, :view_notes, :visual_surrogate, :external_resources,
        :copyright_representatives, :public_domain, :licensing_restriction_uris
      ]
      if action_name == "new" || !current_ability&.admin?
        terms - [:imaging_uid_placeholder]
      else
        terms
      end
    end

    def self.multiple?(term)
      return true if term == :attachment_uris
      super
    end

    self.model_class = ::GenericWork
    # We must inherit from terms even if we aren't using them because Sufia will pass
    # some of them to the controller and they need to be sanitized properly.
    self.terms += aic_terms
    self.required_fields = [:asset_type, :document_type_uri]

    def primary_terms
      self.class.aic_terms(action_name: @action_name, current_ability: @current_ability) - [:asset_type, :external_resources]
    end

    def secondary_terms
      []
    end

    def asset_type
      AssetTypeAssignmentService.new(model).current_type.first
    end

    def uris_for(term)
      model.send(term).map(&:uri).map(&:to_s)
    end

    def uri_for(term)
      return unless model.send(term)
      model.send(term).uri.to_s
    end

    # @return [Array<SolrDocument>]
    # TODO: I don't know if this will work. Forms usually need AF::Base objects
    def representations_for
      representing_resource.representations
    end

    # @return [Array<SolrDocument>]
    # TODO: I don't know if this will work. Forms usually need AF::Base objects
    def documents_for
      representing_resource.documents
    end

    # @return [Array<SolrDocument>]
    # TODO: I don't know if this will work. Forms usually need AF::Base objects
    def attachments_for
      representing_resource.assets
    end

    def preferred_representation_for
      # TODO: need to add this to the relationships tab
    end

    # Overrides hydra-editor MultiValueInput#collection
    def [](term)
      if [:representations_for, :documents_for, :attachments_for].include? term
        send(term)
      else
        super
      end
    end

    private

      def representing_resource
        @representing_resource ||= InboundRelationships.new(model.id)
      end
  end
end
