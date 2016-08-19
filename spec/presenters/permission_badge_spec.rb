# frozen_string_literal: true
require 'rails_helper'

describe PermissionBadge do
  let(:solr_doc) { SolrDocument.new(model.to_solr) }
  subject { described_class.new(solr_doc) }

  context "with a department asset" do
    let(:model)  { build(:department_asset, id: '1234') }
    its(:render) { is_expected.to eq('<span title="Department" class="label label-warning">Department</span>') }
  end

  context "with a registered asset" do
    let(:model)  { build(:registered_asset, id: '1234') }
    its(:render) { is_expected.to eq('<span title="AIC" class="label label-info">AIC</span>') }
  end

  context "with a department file set" do
    let(:model)  { build(:department_file, id: '1234') }
    its(:render) { is_expected.to eq('<span title="Department" class="label label-warning">Department</span>') }
  end
end
