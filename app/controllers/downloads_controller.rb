# frozen_string_literal: true
class DownloadsController < ApplicationController
  include CurationConcerns::DownloadBehavior

  def rights_for_file
    return :read unless thumbnail?
    :discover
  end

  protected

    def authorize_download!
      return params[:id] if current_user.admin?
      authorize! rights_for_file, params[asset_param_key]
    end

    # Loads the file specified by the HTTP parameter `:file`.
    # If this object does not have a file by that name, return the default file
    # as returned by {#default_file}
    # @return [ActiveFedora::File, String, NilClass] Returns the file from the repository or a path to a file on the local file system, if it exists.
    def load_file
      file_reference = params[:file]
      return default_file unless file_reference
      return access_file if access_master?

      file_path = CurationConcerns::DerivativePath.derivative_path_for_reference(params[asset_param_key], file_reference)
      File.exist?(file_path) ? file_path : nil
    end

  private

    def thumbnail?
      params.fetch(:file, nil) == "thumbnail"
    end

    def access_master?
      params.fetch(:file, nil) == "access"
    end

    # We'll use the default CurationConcerns::DerivativePath to look at all the existing derivatives and return the
    # first one with "access" in the name. If there are more derivative types later, we'll want to create out own
    # service to return the exact path for a given derivative type and set that using derivative_path_factory.
    def access_file
      CurationConcerns::DerivativePath.derivatives_for_reference(params[asset_param_key]).each do |file|
        filename = File.basename(file, ".*")
        return file if filename =~ /access/ && File.exist?(file)
      end
    end
end
