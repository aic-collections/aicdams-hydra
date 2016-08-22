# frozen_string_literal: true
class FileSetPresenter < Sufia::FileSetPresenter
  def permission_badge_class
    PermissionBadge
  end
end
