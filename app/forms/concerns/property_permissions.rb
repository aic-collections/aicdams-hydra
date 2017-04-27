# frozen_string_literal: true
# Renders fields in the form un-editable if the user does not have the rights.
module PropertyPermissions
  extend ActiveSupport::Concern

  included do
    # @param [Symbol] field in app/views/records/*
    # @return [Boolean]
    def disabled?(field)
      Judge.new(field, current_ability).disabled?
    end

    private

      class Judge
        attr_reader :permissions, :current_user

        delegate :groups, :admin?, to: :current_user

        def initialize(field, ability)
          @permissions = property_permissions.fetch(field, {})
          @current_user = ability.current_user
        end

        def disabled?
          return false if !permissions.present? || admin? || (permissions.fetch(:only, []) & groups).present?
          true
        end

        def property_permissions
          @property_permissions ||= HashWithIndifferentAccess.new(
            YAML.load_file(File.join(Rails.root, "config", "property_permissions.yml")))
        end
      end
  end
end
