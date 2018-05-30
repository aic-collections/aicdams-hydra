# frozen_string_literal: true
require 'rails_helper'

describe Sufia::BatchUploadsController do
  routes { Sufia::Engine.routes }
  include_context "authenticated saml user"

  subject { described_class }
  let(:uploaded_file) { create(:uploaded_file) }
  let(:work_attributes) { { "asset_type" => AICType.StillImage.to_s, "use_uri" => AICType.IntermediateFileSet.to_s, "uploaded_batch_id" => "999" } }

  its(:form_class) { is_expected.to eq(BatchUploadForm) }

  it "switches the status of Sufia Uploaded File" do
    ActiveJob::Base.queue_adapter = :test
    expect(uploaded_file.status).to eq "new"
    post :create, uploaded_files: [uploaded_file.id.to_s], batch_upload_item: work_attributes
    expect(uploaded_file.reload.status).to eq "begun_ingestion"
    ActiveJob::Base.queue_adapter = :inline
  end
end
