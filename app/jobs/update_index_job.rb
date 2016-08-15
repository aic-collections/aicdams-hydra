# frozen_string_literal: true
class UpdateIndexJob < ActiveJob::Base
  queue_as :resolrize

  def perform(id)
    return unless ActiveFedora::Base.exists?(id)
    ActiveFedora::SolrService.add(ActiveFedora::Base.find(id).to_solr, softCommit: false)
  end
end
