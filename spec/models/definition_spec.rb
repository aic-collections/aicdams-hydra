# frozen_string_literal: true
require 'rails_helper'

describe Definition do
  subject { described_class.new(uri) }

  context "with a plain uri" do
    let(:uri) { "http://definitition.term/Term" }
    its(:uri) { is_expected.to eq(uri) }
    its(:pref_label) { is_expected.to eq(uri) }

    describe "::find" do
      subject { described_class.find(uri) }
      its(:uri) { is_expected.to eq(uri) }
      its(:pref_label) { is_expected.to eq(uri) }
    end
  end

  context "with a vocab term" do
    let(:uri) { AICDocType.DesignFile }
    its(:uri) { is_expected.to eq("http://definitions.artic.edu/doctypes/DesignFile") }
    its(:pref_label) { is_expected.to eq("Design File") }
  end
end
