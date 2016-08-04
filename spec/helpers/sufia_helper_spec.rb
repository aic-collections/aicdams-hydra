# frozen_string_literal: true
require 'rails_helper'

describe SufiaHelper do
  describe "#visibility_options" do
    subject { helper.visibility_options(option) }
    context "with looser restrictions" do
      let(:option) { :loosen }
      it { is_expected.to eq([["Open Access", "open"], ["AIC", "authenticated"]]) }
    end

    context "with tighter restrictions" do
      let(:option) { :restrict }
      it { is_expected.to eq([["Department", "department"], ["AIC", "authenticated"]]) }
    end
  end
end
