# frozen_string_literal: true
class MasterDerivativesJob < ActiveJob::Base
  # clean out the tmp/uploads dir upon successful derivatives generation
  # this also fixes https://cits.artic.edu/issues/3055
  after_perform do |job|
    fs_uri = job.arguments.first.uri.to_s
    sufia_uploaded_file = Sufia::UploadedFile.find_by_file_set_uri(fs_uri)
    sufia_uploaded_file.destroy if sufia_uploaded_file
  end
end
