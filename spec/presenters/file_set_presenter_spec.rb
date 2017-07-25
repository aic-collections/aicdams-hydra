# frozen_string_literal: true
require 'rails_helper'

describe FileSetPresenter do
  let(:solr_document) { SolrDocument.new(file_set.to_solr) }
  let(:ability)	      { nil }
  let(:presenter)     { described_class.new(solr_document, ability) }

  subject { presenter }

  describe "#permission_badge_class" do
    let(:file_set) { build(:file_set, id: '1234') }
    its(:permission_badge_class) { is_expected.to eq(PermissionBadge) }
  end

  describe "#roles" do
    context "with an intermediate file set" do
      let(:file_set) { build(:intermediate_file_set) }
      its(:role) { is_expected.to contain_exactly(AICType.IntermediateFileSet.label) }
    end

    context "with an original file set" do
      let(:file_set) { build(:original_file_set) }
      its(:role) { is_expected.to contain_exactly(AICType.OriginalFileSet.label) }
    end

    context "with a preservation master file set" do
      let(:file_set) { build(:preservation_file_set) }
      its(:role) { is_expected.to contain_exactly(AICType.PreservationMasterFileSet.label) }
    end

    context "with a legacy file set" do
      let(:file_set) { build(:legacy_file_set) }
      its(:role) { is_expected.to contain_exactly(AICType.LegacyFileSet.label) }
    end
  end
end
