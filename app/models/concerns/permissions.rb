# frozen_string_literal: true
module Permissions
  extend ActiveSupport::Concern

  include Readable
  include LakeshoreVisibility
  include WithAICDepositor

  # Any authenticated user can discover assets
  def discover_groups
    super << Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED
  end
end
