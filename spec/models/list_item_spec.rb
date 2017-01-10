# frozen_string_literal: true
require 'rails_helper'

describe ListItem do
  describe "::indexer" do
    subject { described_class }
    its(:indexer) { is_expected.to eq(ListIndexer) }
  end

  describe "::active_status" do
    subject { described_class.active_status }
    its(:pref_label) { is_expected.to eq("Active") }
    its(:type) { is_expected.to include(AICType.StatusType) }
  end
end
