# frozen_string_literal: true
require 'rails_helper'

describe CitiNotificationJob do
  let(:file_set)     { build(:file_set) }
  let(:asset)        { build(:asset) }
  let(:work)         { build(:work, citi_uid: "1234") }
  let(:job)          { described_class.new }
  let(:notification) { CitiNotification.new(file_set, work) }

  describe "#perform" do
    subject { job.perform(file_set, work) }

    context "when the CITI resource is supplied" do
      before do
        WebMock.stub_request(:post, ENV.fetch("citi_api_endpoint"))
               .with(body: notification.to_json)
               .to_return(status: 202, body: "success response")
      end

      it { is_expected.to eq("success response") }
    end

    context "when there is no CITI API UID configured" do
      it "does not send the request to CITI" do
        cached = ENV.fetch("citi_api_uid")
        ENV["citi_api_uid"] = nil
        expect(job.perform(file_set)).to be_nil
        ENV["citi_api_uid"] = cached
      end
    end

    context "when file set is not the preferred representation" do
      before { allow(file_set).to receive(:parent).and_return(asset) }
      it "does not send the request to Citi" do
        expect(HTTParty).not_to receive(:post)
        expect(job.perform(file_set)).to be_nil
      end
    end

    context "when the work is nil" do
      let(:work)         { nil }
      let(:found_work)   { build(:work, citi_uid: "1234") }
      let(:notification) { CitiNotification.new(file_set, found_work) }

      before do
        allow(job).to receive(:find_citi_resource).and_return(found_work)
        WebMock.stub_request(:post, ENV.fetch("citi_api_endpoint"))
               .with(body: notification.to_json)
               .to_return(status: 202, body: "success response")
      end

      it { is_expected.to eq("success response") }
    end

    context "when the file set is nil indicating the relationship was removed" do
      let(:file_set) { nil }

      before do
        WebMock.stub_request(:post, ENV.fetch("citi_api_endpoint"))
               .with(body: notification.to_json)
               .to_return(status: 202, body: "success response")
      end

      it { is_expected.to eq("success response") }
    end

    context "when CITI returns an unsuccessful response" do
      let(:error) { "CITI notification failed. Expected 202 but received 404. Error message body" }

      before do
        WebMock.stub_request(:post, ENV.fetch("citi_api_endpoint"))
               .with(body: notification.to_json)
               .to_return(status: 404, body: "Error message body")
      end

      it "raises an error" do
        expect { job.perform(file_set, work) }.to raise_error(Lakeshore::CitiNotificationError, error)
      end
    end
  end
end
