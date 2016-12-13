# frozen_string_literal: true
class DeleteIndexJob < ActiveJob::Base
  queue_as :resolrize

  def perform(id)
    return if ActiveFedora::Base.exists?(id)
    ActiveFedora::SolrService.instance.conn.delete_by_id(id, params: { softCommit: false })
  end
end
