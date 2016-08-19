# frozen_string_literal: true
require 'rails_helper'

describe BatchUploadForm do
  let(:user)    { create(:user1) }
  let(:ability) { Ability.new(user) }
  let(:batch)   { BatchUploadItem.new }
  let(:form)    { described_class.new(batch, ability) }

  describe "class methods" do
    subject { described_class }

    describe "::terms" do
      its(:terms) { is_expected.to eq(CurationConcerns::GenericWorkForm.terms) }
    end

    describe "::build_permitted_params" do
      its(:build_permitted_params) { is_expected.to include(:asset_type) }
    end
  end

  describe "instance methods" do
    subject { form }

    describe "#dept_created" do
      its(:dept_created) { is_expected.to be_kind_of(Department) }
    end

    describe "#primary_terms" do
      its(:primary_terms) { is_expected.not_to include(:asset_type, :pref_label) }
    end

    describe "#secondary_terms" do
      its(:secondary_terms) { is_expected.to be_empty }
    end
  end
end
