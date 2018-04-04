# frozen_string_literal: true
module AssetMetadata
  extend ActiveSupport::Concern

  included do
    property :capture_device, predicate: AIC.captureDevice, multiple: false do |index|
      index.as :stored_searchable
    end

    property :digitization_source, predicate: AIC.digitizationSource, multiple: false, class_name: "ListItem"

    property :document_type, predicate: AIC.documentType, multiple: false, class_name: "Definition"
    property :first_document_sub_type, predicate: AIC.documentSubType1, multiple: false, class_name: "Definition"
    property :second_document_sub_type, predicate: AIC.documentSubType2, multiple: false, class_name: "Definition"

    # Force these to singular terms. Ensure a nil or empty set forces a change.
    def document_type=(value)
      document_type_will_change! unless value.present?
      if value.respond_to?(:each)
        super(value.first)
      else
        super(value)
      end
    end

    def first_document_sub_type=(value)
      first_document_sub_type_will_change! unless value.present?
      if value.respond_to?(:each)
        super(value.first)
      else
        super(value)
      end
    end

    def second_document_sub_type=(value)
      second_document_sub_type_will_change! unless value.present?
      if value.respond_to?(:each)
        super(value.first)
      else
        super(value)
      end
    end

    property :legacy_uid, predicate: AIC.legacyUid do |index|
      index.as :stored_searchable
    end

    property :keyword, predicate: AIC.keyword, class_name: "ListItem" do |index|
      index.as :stored_searchable, :facetable, using: :pref_label
    end

    property :external_resources, predicate: AIC.hasExternalContent do |index|
      index.as :stored_searchable
    end

    property :publish_channels, predicate: AIC.publishChannel, class_name: "PublishChannel"

    # @todo this should be renamed attachment_of for consistency, and can be done during #1682
    property :attachments, predicate: AIC.isAttachmentOf, class_name: "GenericWork"

    property :constituent_of, predicate: AIC.isConstituentPartOf, class_name: "GenericWork"

    property :copyright_representatives, predicate: AIC.copyrightRepresentative, class_name: "Agent" do |index|
      index.as :stored_searchable, using: :pref_label
    end

    property :licensing_restrictions, predicate: AIC.licensingRestriction, class_name: "ListItem" do |index|
      index.as :stored_searchable, using: :pref_label
    end

    property :public_domain, predicate: AIC.publicDomain, multiple: false

    property :publishable, predicate: AIC.isPublishable, multiple: false

    property :caption, predicate: AIC.nonObjCaption, multiple: false do |index|
      index.as :stored_searchable
    end

    accepts_uris_for :keyword, :digitization_source, :document_type, :first_document_sub_type,
                     :second_document_sub_type, :publish_channels, :attachments, :copyright_representatives,
                     :licensing_restrictions, :constituent_of
  end
end
