# frozen_string_literal: true
class ListItem < ActiveFedora::Base
  include Hydra::PCDM::ObjectBehavior
  include BasicMetadata

  self.indexer = ListIndexer

  type [AICType.Resource, AICType.ListItem]

  # A special case: we need the list item for our active status because it's required for all objects
  def self.active_status
    find_by_uid("ST-1")
  end
end
