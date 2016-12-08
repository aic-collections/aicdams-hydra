# frozen_string_literal: true
require 'rails_helper'
require 'open3'

describe Hydra::Derivatives::Processors::Image do
  include Open3
  let(:file_name) { "file_name" }
  subject { described_class.new(file_name, directives) }

  describe "#process" do
    context "when running the command on a small image", unless: in_travis? do
      let(:directives) { { format: "jp2[512x512]", url: "file:#{Rails.root}/tmp/derivatives/s-access.jp2" } }
      let(:file_name) { File.join(fixture_path, "tardis.png") }
      it "converts the image" do
        expect(described_class).to receive(:execute).with("#{Rails.application.secrets.hydra_bin_path}mogrify #{Rails.root}/tmp/derivatives/s-access.jp2")
        subject.process

        _stdin, _stdout, _stderr = popen3("rm -rf #{Rails.root}/tmp/derivatives/s-access.jp2")
      end
    end

    context "when running the command", unless: in_travis? do
      let(:directives) { { format: "jp2[512x512]", url: "file:#{Rails.root}/tmp/derivatives/t-access.jp2" } }
      let(:file_name) { File.join(fixture_path, "3500_test.png") }
      it "converts and resizes the image" do
        expect(described_class).to receive(:execute).with("#{Rails.application.secrets.hydra_bin_path}mogrify -resize 3000x #{Rails.root}/tmp/derivatives/t-access.jp2")
        subject.process

        _stdin, _stdout, _stderr = popen3("rm -rf #{Rails.root}/tmp/derivatives/t-access.jp2")
      end
    end
  end
end
