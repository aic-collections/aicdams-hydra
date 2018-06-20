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
  end
end
