# frozen_string_literal: true
require 'rails_helper'

describe BatchUploadForm do
  let(:user)    { create(:user1) }
  let(:ability) { Ability.new(user) }
  let(:batch)   { BatchUploadItem.new }
  let(:form)    { described_class.new(batch, ability) }

  describe "class methods" do
    subject { described_class }

    its(:terms) { is_expected.to eq(CurationConcerns::GenericWorkForm.terms) }
    its(:build_permitted_params) { is_expected.to include(:asset_type, external_resources: []) }
    its(:model_class) { is_expected.to eq(BatchUploadItem) }
  end

  describe "instance methods" do
    subject { form }

    its(:dept_created) { is_expected.to be_kind_of(Department) }
    its(:primary_terms) { is_expected.not_to include(:asset_type, :pref_label, :external_resources) }
    its(:secondary_terms) { is_expected.to be_empty }
    its(:representations_for) { is_expected.to be_empty }
    its(:preferred_representation_for) { is_expected.to be_empty }
    its(:documents_for) { is_expected.to be_empty }
    its(:attachment_uris) { is_expected.to be_empty }
    its(:attachments_for) { is_expected.to be_empty }
    its(:constituent_of_uris) { is_expected.to be_empty }
    its(:has_constituent_part) { is_expected.to be_empty }
    its(:use_uri) { is_expected.to eq(AICType.IntermediateFileSet) }
    its(:visibility) { is_expected.to eq("department") }
    its(:external_file) { is_expected.to be_nil }
    its(:external_file_label) { is_expected.to be_nil }
    its(:copyright_representatives) { is_expected.to be_empty }
    its(:use_uri) { is_expected.to eq(AICType.IntermediateFileSet) }
    its(:visibility) { is_expected.to eq("department") }
  end
end
