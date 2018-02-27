# frozen_string_literal: true
class BatchUploadForm < Sufia::Forms::BatchUploadForm
  include AssetFormBehaviors
  include PropertyPermissions

  attr_writer :parameterized_relationships

  self.terms = CurationConcerns::GenericWorkForm.terms

  delegate :representations_for, :documents_for, :attachment_uris, :attachments_for, to: :parameterized_relationships

  def primary_terms
    CurationConcerns::GenericWorkForm.aic_terms - [:asset_type, :pref_label, :external_resources]
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

  # @return nil
  # A noop so that we can render custom inputs that aren't tied to the model
  def external_file
  end

  # @return nil
  # A noop so that we can render custom inputs that aren't tied to the model
  def external_file_label
  end

  def copyright_representatives
    []
  end

  # TODO: delegate this to parameterized_relationships later when we want to add this relationship via the url
  def preferred_representation_for
    []
  end

  # Overrides hydra-editor MultiValueInput#collection
  def [](term)
    if [:imaging_uid, :view_notes].include? term
      []
    else
      super
    end
  end

  def visibility
    ::Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
  end

  private

    # If parameterized_relationships has not been set, return a null pattern object
    def parameterized_relationships
      @parameterized_relationships || OpenStruct.new(representations_for: [],
                                                     documents_for: [],
                                                     attachment_uris: [],
                                                     attachments_for: [])
    end
end
