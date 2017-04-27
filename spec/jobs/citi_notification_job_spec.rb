# frozen_string_literal: true
require 'rails_helper'

describe CitiNotificationJob do
  let(:file_set)  { create(:file_set) }
  let(:asset)     { create(:asset) }
  let(:work)      { create(:work, citi_uid: "1234") }
  let(:mock_file) { double("MockFile", fcrepo_modified: [Time.now]) }
  let(:job)       { described_class.new }

  before do
    WebMock.enable!
    allow(file_set).to receive(:original_file).and_return(mock_file)
  end

  describe "a successful outcome" do
    context "when the CITI resource is supplied" do
      it "sends a POST request to Citi" do
        VCR.use_cassette("citi_notify", record: :none) do
          job.perform(file_set, work)
        end
      end
    end

    context "when file set is not the preferred representation" do
      before { allow(file_set).to receive(:parent).and_return(asset) }
      it "does not send a POST request to Citi" do
        expect(HTTParty).not_to receive(:post)
        job.perform(file_set)
      end
    end

    context "when the file set in nil indicating the relationship was removed" do
      it "sends a POST request to Citi" do
        VCR.use_cassette("citi_notify_remove", record: :none) do
          job.perform(nil, work)
        end
      end
    end
  end

  describe "an unsuccessful outcome" do
    it "raises an error" do
      VCR.use_cassette("citi_notify_error", record: :none) do
        expect { job.perform(file_set, work) }.to raise_error(StandardError, start_with("CITI notification failed"))
      end
    end
  end
end
