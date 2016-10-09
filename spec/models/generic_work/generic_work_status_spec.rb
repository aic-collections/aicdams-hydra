# frozen_string_literal: true
require 'rails_helper'

describe "GenericFile" do
  let(:example_file) { create(:asset) }

  subject { example_file }

  describe "#status" do
    context "by default" do
      it { is_expected.to be_active }
    end
  end

  describe "#status_uri" do
    let(:new_status) { create(:status_type, pref_label: "New") }
    before { example_file.status_uri = new_status.uri }
    its(:status) { is_expected.to eq(new_status) }
    it { is_expected.not_to be_active }
  end
end
