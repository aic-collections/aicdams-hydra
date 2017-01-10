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
    super || ListItem.active_status
  end

  def notify_citi
    if preferred_representation.nil?
      CitiNotificationJob.perform_later(nil, self)
    elsif preferred_representation.intermediate_file_set.present?
      CitiNotificationJob.perform_later(preferred_representation.intermediate_file_set.first, self)
    end
  end
end
