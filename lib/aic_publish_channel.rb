# frozen_string_literal: true
class AICPublishChannel < RDF::StrictVocabulary("http://definitions.artic.edu/publish_channel/")
  term :Web,
       label: "Web"
  term :TrustedParty,
       label: "Trusted Party"
  term :InMuseumApps,
       label: "In-Museum Apps"
  term :Multimedia,
       label: "Multimedia"
  term :EducationalResources,
       label: "Educational Resources"
  term :TeacherResources,
       label: "Teacher Resources"

  def self.options
    options = {}
    map { |channel| options[channel.label] = channel.to_uri }
    options
  end
end
