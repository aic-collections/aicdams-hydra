# frozen_string_literal: true
# Common actor for all CITI resources
class CitiResourceActor < CurationConcerns::Actors::BaseActor
  # @param [Hash] attributes from the form
  def update(attributes)
    pref_rep = attributes.fetch("preferred_representation_uri", "")
    reps = attributes.fetch("representation_uris", [""])

    if pref_rep.to_s.empty?
      attributes["preferred_representation_uri"] = reps.first
    elsif !normal_representation?(reps, pref_rep)
      reps << pref_rep
    end

    super
  end

  protected

    def normal_representation?(reps, pref_rep)
      reps.include? pref_rep
    end

    def save
      notify_citi if curation_concern.preferred_representation_changed?
      super
    end

    def notify_citi
      if curation_concern.preferred_representation.nil?
        CitiNotificationJob.perform_later(nil, curation_concern)
      elsif curation_concern.preferred_representation.intermediate_file_set.present?
        CitiNotificationJob.perform_later(curation_concern.preferred_representation.intermediate_file_set.first, curation_concern)
      end
    end
end
