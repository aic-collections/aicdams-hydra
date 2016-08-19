# frozen_string_literal: true
module Permissions
  module Readable
    extend ActiveSupport::Concern

    def department?
      !(public? || registered?)
    end

    # Private visibility is disabled. Overrides CurationConcerns::Permissions::Readable
    def private?
      false
    end
  end
end
