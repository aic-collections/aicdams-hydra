# frozen_string_literal: true
require 'rails_helper'

describe AICDocType do
  subject { described_class.find_term(uri) }

  context "with an image type" do
    describe "retrieving a label with a given uri" do
      let(:uri) { "http://definitions.artic.edu/doctypes/MembershipEvent" }
      its(:label) { is_expected.to eq("Membership event") }
    end
  end

  context "with a text type" do
    describe "retrieving a label with a given uri" do
      let(:uri) { "http://definitions.artic.edu/doctypes/ExhibitionContract" }
      its(:label) { is_expected.to eq("Exhibition Contract") }
    end
  end
end
