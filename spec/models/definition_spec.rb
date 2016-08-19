# frozen_string_literal: true
require 'rails_helper'

describe Definition do
  let(:uri) { "http://definitition.term/Term" }
  subject { described_class.new(uri) }

  its(:uri) { is_expected.to eq(uri) }
  its(:pref_label) { is_expected.to eq(uri) }

  describe "::find" do
    subject { described_class.find(uri) }
    its(:uri) { is_expected.to eq(uri) }
    its(:pref_label) { is_expected.to eq(uri) }
  end
end
