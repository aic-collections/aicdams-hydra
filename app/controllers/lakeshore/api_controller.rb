# frozen_string_literal: true
module Lakeshore
  class APIController < ActionController::Base
    before_action :authenticate_api_user

    def authenticate_api_user
      authenticate_or_request_with_http_basic do |username, password|
        resource = User.find_by_email(username)
        return head :unauthorized unless resource
        if resource.valid_password?(password) && resource.api?
          if params[:depositor]
            sign_in :user, User.find_by_email!(params[:depositor])
          else
            sign_in :user, resource
          end
        end
      end
    end

    def validate_depositor
      unless AICUser.find_by_nick(params[:depositor])
        render plain: "AICUser '#{params[:depositor]}' not found, contact collections_support@artic.edu\n", status: 500
      end
    end
  end
end
