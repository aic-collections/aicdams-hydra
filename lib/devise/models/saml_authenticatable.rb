# frozen_string_literal: true
require 'devise/strategies/saml_authenticatable'
module Devise
  module Models
    module SamlAuthenticatable
      extend ActiveSupport::Concern

      def after_database_authentication
      end

      # Since Shibboleth is controlling authentication, we can update any user attributes without using a password.
      # Overrides Devise::Models::DatabaseAuthenticatable.update_with_password
      def update_with_password(params, *options)
        update_without_password(params, *options)
      end

      # Overrides Devise::Models::DatabaseAuthenticatable.update_without_password
      def update_without_password(params, *options)
        params.delete(:password)
        params.delete(:password_confirmation)

        result = update_attributes(params, *options)
        result
      end
    end
  end
end
