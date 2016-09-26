# frozen_string_literal: true
# Intercepts the existing #depositor methods and replaces them with an
# #aic_depositor method that uses the same predicate but with an AICUser resource.
module Permissions::WithAICDepositor
  extend ActiveSupport::Concern

  included do
    property :aic_depositor, predicate: ::RDF::Vocab::MARCRelators.dpt, multiple: false, class_name: "AICUser"
    property :dept_created, predicate: AIC.deptCreated, multiple: false, class_name: "Department"

    def depositor=(depositor)
      self.aic_depositor = AICUser.find_by_nick(depositor).uri
    end

    # To retain Sufia's expectations, #depositor will return the nick of the AICUser
    def depositor
      return unless aic_depositor
      aic_depositor.nick
    end

    def apply_depositor_metadata(depositor)
      user = depositor.is_a?(User) ? depositor : User.find_by_email(depositor)
      return unless user
      apply_aic_user_metadata(user)
      true
    end

    private

      def apply_aic_user_metadata(user)
        self.aic_depositor = AICUser.find_by_nick(user.email).uri
        self.dept_created = Department.find_by_citi_uid(user.department).uri
        self.edit_users += [user.email]
      end
  end
end
