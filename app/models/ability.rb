# frozen_string_literal: true
class Ability
  include Hydra::Ability
  include CurationConcerns::Ability
  include Sufia::Ability

  self.ability_logic += [:everyone_can_create_curation_concerns,
                         :admins_can_manage_lists,
                         :departments_can_read_assets,
                         :users_can_edit_citi_resources
                        ]

  def admins_can_manage_lists
    can :manage, List if admin?
  end

  def departments_can_read_assets
    can :read, GenericWork do |obj|
      !obj.department?
    end
  end

  def users_can_edit_citi_resources
    can :edit, [Work, Exhibition, Agent, Transaction, Shipment, Place] if registered_user?
  end
end
