# frozen_string_literal: true
class User < ActiveRecord::Base
  include Hydra::User
  include CurationConcerns::User
  include Sufia::User
  include Sufia::UserUsageStats

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :password, :password_confirmation
  end

  Devise.add_module(:saml_authenticatable,
                    strategy: true,
                    controller: :sessions,
                    model: 'devise/models/saml_authenticatable')

  devise :saml_authenticatable, :database_authenticatable

  # TODO: Add additional attributes from Shibboleth properties
  def populate_attributes
    self
  end

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  def admin?
    groups.include?('admin')
  end

  def api?
    groups.include?('api')
  end

  def groups
    groups = super
    groups << department
    groups.compact
  end

  def self.find_by_email(query)
    User.where(email: query).first
  end

  def self.batch_user
    User.find_by_user_key(batch_user_key) || User.create!(Devise.authentication_keys.first => batch_user_key)
  end

  def self.audit_user
    User.find_by_user_key(audit_user_key) || User.create!(Devise.authentication_keys.first => audit_user_key)
  end

  def aic_user
    AICUser.find_by_nick(email)
  end
end
