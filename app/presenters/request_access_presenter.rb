# frozen_string_literal: true
class RequestAccessPresenter < UnauthorizedPresenter
  def initialize(resource_id, user, resource_type)
    super(resource_id, resource_type)
    @requester = user
  end

  attr_reader :requester

  def requester_email
    "#{requester}@artic.edu"
  end

  def depositor_email
    "#{resource.aic_depositor}@artic.edu"
  end

  def requester_pretty_name
    aic_user = AICUser.find_by_nick(requester)
    [aic_user.given_name, aic_user.family_name].join(" ")
  end
end
