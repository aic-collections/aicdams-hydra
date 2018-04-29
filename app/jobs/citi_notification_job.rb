# frozen_string_literal: true
class CitiNotificationJob < ActiveJob::Base
  queue_as :event

  attr_reader :file_set, :citi_resource

  # @param [FileSet] file_set
  # @param [CitiResource] citi_resource
  # When the citi_resource is supplied, it is assumed that the accompanying file set is the correct one
  # containing the preferred representation.
  def perform(file_set, citi_resource = nil, imaging_uid_update = nil)
    return unless ENV.fetch("citi_api_uid", nil)
    citi_resource ||= find_citi_resource(file_set)
    return unless citi_resource
    post = notify(CitiNotification.new(file_set, citi_resource, imaging_uid_update))
    return post.body if post.response.code.to_i == 202
    raise Lakeshore::CitiNotificationError,
          "CITI notification failed. Expected 202 but received #{post.response.code}. #{post.body}"
  end

  private

    # @todo This logic should be moved into CitiNotification
    def find_citi_resource(file_set)
      intermediate_file_set = file_set.parent.intermediate_file_set.first
      return unless intermediate_file_set && intermediate_file_set.id == file_set.id
      InboundRelationships.new(file_set.parent).preferred_representation
    end

    def notify(notification)
      notification_log.info("Notifying #{ENV.fetch('citi_api_endpoint')} with #{notification}")
      HTTParty.post(
        ENV.fetch("citi_api_endpoint"),
        body: notification.to_json,
        verify: verify_ssl?,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def verify_ssl?
      return false if ENV.fetch("citi_api_ssl_verify", "true") == "false"
      true
    end

    def notification_log
      @notification_log ||= Logger.new("#{Rails.root}/log/citi_notification.log")
    end
end
