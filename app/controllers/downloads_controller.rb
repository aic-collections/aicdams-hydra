# frozen_string_literal: true
class DownloadsController < ApplicationController
  include CurationConcerns::DownloadBehavior

  def rights_for_file
    return :read unless thumbnail?
    :discover
  end

  protected

    def authorize_download!
      authorize! rights_for_file, params[asset_param_key]
    end

  private

    def thumbnail?
      params.fetch(:file, nil) == "thumbnail"
    end
end
