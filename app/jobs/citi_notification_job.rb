# frozen_string_literal: true
class CitiNotificationJob < ActiveJob::Base
  queue_as :event

  attr_reader :file_set, :citi_resource

  # @param [FileSet] file_set
  # @param [CitiResource] citi_resource
  # When the citi_resource is supplied, it is assumed that the accompanying file set is the correct one
  # containing the preferred representation.
  def perform(file_set, citi_resource = nil)
    return unless ENV.fetch("citi_api_uid", nil)
    @file_set = file_set
    @citi_resource = citi_resource || find_citi_resource
    notify_citi if @citi_resource
  end

  private

    def notify_citi
      return post.body if post.response.code.to_i == 200
      raise StandardError, "CITI notification failed. #{post.body}"
    end

    def find_citi_resource
      return unless intermediate_file_set && intermediate_file_set.id == file_set.id
      InboundRelationships.new(file_set.parent).preferred_representation
    end

    def body
      {
        uid: ENV.fetch("citi_api_uid"),
        password: ENV.fetch("citi_api_password"),
        type: citi_resource.class.to_s,
        citi_uid: citi_resource.citi_uid,
        image_uid: file_set.id,
        last_modified: file_set.modified_date.iso8601
      }
    end

    def post
      @post ||= HTTParty.post(ENV.fetch("citi_api_endpoint"),
                              body: body.to_json,
                              verify: verify_ssl?,
                              headers: { 'Content-Type' => 'application/json' })
    end

    def intermediate_file_set
      @intermediate_file_set ||= file_set.parent.intermediate_file_set.first
    end

    def verify_ssl?
      return false if ENV.fetch("citi_api_ssl_verify", "true") == "false"
      true
    end
end
