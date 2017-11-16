# frozen_string_literal: true
require 'rails_helper'

describe CurationConcernHelper do
  describe "#custom_h1" do
    let(:gw) { GenericWork.new }
    let(:bui) { BatchUploadItem.new }
    let(:action_name) { "new" }

    it "returns custom string for single new GenericWork asset" do
      expect(helper.custom_h1(gw, action_name)).to eq("Create New Asset")
    end
    it "returns something different for a new non-GenericWork" do
      expect(helper.custom_h1(bui, action_name)).not_to eq("Create New Asset")
    end
  end
end
