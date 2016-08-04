# frozen_string_literal: true
module Permissions
  extend ActiveSupport::Concern

  include Readable
  include LakeshoreVisibility
  include WithAICDepositor
end
