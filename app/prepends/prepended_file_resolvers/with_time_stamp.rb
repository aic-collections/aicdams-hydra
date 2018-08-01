# frozen_string_literal: true

class RemoteFileWithTimestamp < Riiif::HTTPFileResolver::RemoteFile
  def file_name
    @cache_file_name ||= ::File.join(cache_path, Digest::MD5.hexdigest(url + File.mtime(url).to_s) + ext.to_s)
  end
end

module PrependedFileResolvers::WithTimeStamp
  def find(id)
    remote = RemoteFileWithTimestamp.new(uri(id),
                                         cache_path: cache_path,
                                         basic_auth_credentials: basic_auth_credentials)
    Riiif::File.new(remote.fetch)
  end
end
