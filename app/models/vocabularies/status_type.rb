# frozen_string_literal: true
# A specific kind of ListItem that is only a member of the Status list
class StatusType < ListItem
  type [AICType.Resource, AICType.ListItem, AICType.StatusType]

  property :identifier, predicate: ::RDF::Vocab::DC.identifier, multiple: false do |index|
    index.type :integer
  end

  def self.active
    find_by_label("Active")
  end
end
