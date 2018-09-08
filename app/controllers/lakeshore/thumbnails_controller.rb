# frozen_string_literal: true
module Lakeshore
  class ThumbnailsController < PubAPIController
    before_action :set_file_set_id_from_asset_uuid, :set_file

    include CurationConcerns::DownloadBehavior
    include DownloadBehavior

    skip_before_action :authorize_download!

    def set_file
      params[:file] = "thumbnail"
    end

    def set_file_set_id_from_asset_uuid
      asset = GenericWork.find(params[:asset_uuid])
      fs_id = asset.intermediate_file_set.first.id
      params[:id] = fs_id
    end
  end
end
