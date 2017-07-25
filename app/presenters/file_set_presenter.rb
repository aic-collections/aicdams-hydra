# frozen_string_literal: true
class FileSetPresenter < Sufia::FileSetPresenter
  delegate :rdf_types, to: :solr_document

  def permission_badge_class
    PermissionBadge
  end

  def role
    (rdf_types & available_roles.keys).map { |uri| available_roles[uri].label }
  end

  private

    # AICType.find doesn't seem work, so we have to do some key/value matching in order
    # to map AICType uris back to their terms.
    def available_roles
      {
        AICType.IntermediateFileSet.to_s       => AICType.IntermediateFileSet,
        AICType.OriginalFileSet.to_s           => AICType.OriginalFileSet,
        AICType.PreservationMasterFileSet.to_s => AICType.PreservationMasterFileSet,
        AICType.LegacyFileSet.to_s             => AICType.LegacyFileSet
      }
    end
end
