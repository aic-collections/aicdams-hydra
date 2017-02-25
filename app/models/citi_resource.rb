# frozen_string_literal: true
class CitiResource < Resource
  include CitiResourceMetadata
  include Sufia::WithEvents

  def self.aic_type
    super << AICType.CitiResource
  end

  type aic_type

  before_save :notify_citi, if: :preferred_representation_changed?

  # Status defaults to active if it is nil
  def status
    super || StatusType.active
  end

  def notify_citi
    return unless preferred_representation && preferred_representation.intermediate_file_set.present?
    CitiNotificationJob.perform_later(preferred_representation.intermediate_file_set.first, self)
  end
end
