# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::LicenseService do
  describe "#label" do
    subject { described_class.new.label(value) { value } }
    context "when id isn't found" do
      let(:value) { "penguin" }
      it "returns value" do
        expect(subject).to eq(value)
      end
      it "doesn't raise error" do
        expect { subject }.not_to raise_error(KeyError)
      end
    end
  end
end
