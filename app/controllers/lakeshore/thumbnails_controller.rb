# frozen_string_literal: true
module Lakeshore
  class ThumbnailsController < PubAPIController
    include CurationConcerns::DownloadBehavior

    before_action :set_file_set_id_from_asset_uuid

    def set_file_set_id_from_asset_uuid
      asset = GenericWork.find(params[:asset_uuid])
      fs_id = asset.intermediate_file_set.first.id
      params[:id] = fs_id
    end
  end
end
