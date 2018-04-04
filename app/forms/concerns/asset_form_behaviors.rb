# frozen_string_literal: true
# Module for defining form behaviors that are included in both GenericWorkForm and BatchUploadForm.
module AssetFormBehaviors
  extend ActiveSupport::Concern

  included do
    # return [Array<Hash, Symbol>]
    # Defines which parameters are allowed to pass from parameter hash to the object for updating.
    # Any parameter that is a defined field in the form object's terms will be included by default;
    # however, sometimes we need to provide additional parameters that are outside of the terms defined
    # on the object. These would include parameters that are passed as uris, representation parameters,
    # or parameters that get passed in from the API and not from the UI.
    def self.build_permitted_params
      super + [
        { rights_holder_uris: [] },
        { view_uris: [] },
        { keyword_uris: [] },
        { representations_for: [] },
        { documents_for: [] },
        { attachments_for: [] },
        { has_constituent_part: [] },
        { preferred_representation_for: [] },
        { publish_channel_uris: [] },
        { imaging_uid: [] },
        { view_notes: [] },
        { attachment_uris: [] },
        { constituent_of_uris: [] },
        { licensing_restriction_uris: [] },
        :document_type_uri,
        :first_document_sub_type_uri,
        :second_document_sub_type_uri,
        :digitization_source_uri,
        :compositing_uri,
        :light_type_uri,
        :status_uri,
        :asset_type,
        :additional_representation,
        :additional_document,
        :uid,
        :dept_created,
        :created,
        :updated,
        :external_file,
        :external_file_label,
        :batch_uid
      ]
    end

    # The default file set type created for each asset
    def use_uri
      AICType.IntermediateFileSet
    end
  end
end
