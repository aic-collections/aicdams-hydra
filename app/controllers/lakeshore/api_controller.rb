# frozen_string_literal: true
module Lakeshore
  class APIController < ActionController::Base
    before_action :validate_depositor, if: :new_controller_that_has_depositor_at_base_level
    before_action :authenticate_api_user

    # check that depositor exists as AICUser
    def validate_depositor
      unless AICUser.find_by_nick(params[:depositor])
        render plain: "AICUser '#{params[:depositor]}' not found, please review the depositor.\n", status: 400
      end
    end

    # return true for controllers that will have depositor at base level
    def new_controller_that_has_depositor_at_base_level
      controller_name == "file_sets"
    end

    def authenticate_api_user
      authenticate_or_request_with_http_basic do |username, password|
        resource = User.find_by_email(username)
        return head :unauthorized unless resource
        if resource.valid_password?(password) && resource.api?
          if params[:depositor] # need an if since ingest api does not have this param. new as of 1.7.5
            sign_in :user, User.find_by_email!(params[:depositor])
          else
            sign_in :user, resource
          end
        end
      end
    end
  end
end
