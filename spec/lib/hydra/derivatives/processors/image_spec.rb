# frozen_string_literal: true
require 'rails_helper'
require 'open3'

describe Hydra::Derivatives::Processors::Image do
  include Open3
  let(:file_name) { "file_name" }
  subject { described_class.new(file_name, directives) }

  describe "#process" do
    let(:mock_image) { double("MockImage") }
    let(:mock_tool)  { double("MockTool") }
    let(:directives) { { label: :access, size: "3000x3000>", format: 'jp2', url: "file:#{Rails.root}/tmp/derivatives/r-access.jp2" } }

    context "with an image" do
      before do
        allow(subject).to receive(:load_image_transformer).and_return(mock_image)
        allow(mock_image).to receive(:type).and_return("tiff")
        allow(MiniMagick::Tool::Convert).to receive(:new).and_yield(mock_tool)
      end

      it "resizes, formats and flattens psd files" do
        expect(mock_image).not_to receive(:layers)
        expect(mock_image).to receive(:path).and_return("/path").twice
        expect(mock_tool).to receive(:<<).with("/path").twice
        expect(mock_tool).to receive(:flatten)
        expect(mock_tool).to receive(:resize).with("3000x3000>")
        expect(mock_image).to receive(:format).with("jp2")
        expect(subject).to receive(:write_image).with(mock_image)
        subject.process
      end
    end

    context "with a pdf" do
      before { allow(subject).to receive(:load_image_transformer).and_return(mock_image) }
      it "uses the original and does not resize, format, or flatten" do
        allow(mock_image).to receive(:type).and_return("pdf")
        expect(mock_image).not_to receive(:layers)
        expect(mock_image).not_to receive(:flatten)
        expect(mock_image).not_to receive(:resize)
        expect(mock_image).not_to receive(:format)
        expect(subject).not_to receive(:write_image)
        subject.process
      end
    end

    context "when mogrify is needed", unless: LakeshoreTesting.continuous_integration? do
      let(:directives) { { label: :access, format: "jp2", size: "3000x3000>", url: "file:#{Rails.root}/tmp/derivatives/s-access.jp2" } }
      let(:file_name) { File.join(fixture_path, "tardis.png") }
      it "runs a shell command to convert the image" do
        expect(described_class).to receive(:execute).with("#{File.join(ENV['hydra_bin_path'], 'gm')} mogrify  #{Rails.root}/tmp/derivatives/s-access.jp2")
        subject.process

        _stdin, _stdout, _stderr = popen3("rm -rf #{Rails.root}/tmp/derivatives/s-access.jp2")
      end
    end
  end
end
