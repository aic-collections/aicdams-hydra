# frozen_string_literal: true
class BatchUploadForm < Sufia::Forms::BatchUploadForm
  self.terms = CurationConcerns::GenericWorkForm.terms

  def primary_terms
    CurationConcerns::GenericWorkForm.aic_terms - [:asset_type, :pref_label]
  end

  def secondary_terms
    []
  end

  def dept_created
    Department.find_by_citi_uid(current_ability.current_user.department)
  end

  def uri_for(term)
    # noop
  end

  def uris_for(term)
    # noop
  end

  def representations_for
    []
  end

  def documents_for
    []
  end

  def self.build_permitted_params
    super + [
      { rights_holder_uris: [] },
      { view_uris: [] },
      { keyword_uris: [] },
      { representations_for: [] },
      { documents_for: [] },
      :document_type_uri,
      :first_document_sub_type_uri,
      :second_document_sub_type_uri,
      :digitization_source_uri,
      :compositing_uri,
      :light_type_uri,
      :status_uri,
      :asset_type,
      :additional_representation,
      :additional_document
    ]
  end
end
