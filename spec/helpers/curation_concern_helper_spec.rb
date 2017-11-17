# frozen_string_literal: true
require 'rails_helper'

describe CurationConcernHelper do
  describe "#custom_h1" do
    let(:gw) { GenericWork.new }
    let(:bui) { BatchUploadItem.new }

    it "returns custom string for single new GenericWork asset" do
      expect(helper.custom_h1(gw)).to eq("Create New Asset")
    end
    it "returns something different for a new non-GenericWork" do
      expect(helper.custom_h1(bui)).not_to eq("Create New Asset")
    end
  end
end
