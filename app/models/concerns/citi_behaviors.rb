# frozen_string_literal: true
# Resources loaded into Fedora from CITI. Although they are defined ActiveFedora models, they operate
# slightly differently than Sufia's other classes. These are some basic methods
# that allow them to behave with other objects.
module CitiBehaviors
  extend ActiveSupport::Concern
  include Permissions::Readable

  included do
    self.indexer = CitiIndexer
  end

  class_methods do
    def visibility
      Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    end
  end

  def registered?
    true
  end

  def featureable?
    false
  end

  # Override CurationConcerns::Permissions
  # This avoids the "Depositor must have edit access" error message because
  # CITI resources aren't created in Lakeshore, and therefore don't have depositors.
  def paranoid_permissions
    true
  end

  # All authenticated users can edit Citi resources
  def edit_groups
    super << Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED
  end
end
