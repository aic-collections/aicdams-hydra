# frozen_string_literal: true
# To keep helper modules better defined, the only methods in SufiaHelper override those
# from the other included modules. New or otherwise unique methods should be placed in
# either ApplicationHelper or a different module that is not included here.
module SufiaHelper
  include ::BlacklightHelper
  include CurationConcerns::MainAppHelpers
  include Sufia::BlacklightOverride
  include Sufia::SufiaHelperBehavior

  def visibility_options(variant)
    options = [
      Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC,
      Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED,
      Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
    ]
    case variant
    when :restrict
      options.delete_at(0)
      options.reverse!
    when :loosen
      options.delete_at(2)
    end
    options.map { |value| [visibility_text(value), value] }
  end

  private

    def render_visibility_label(document)
      PermissionBadge.new(document).render
    end
end
