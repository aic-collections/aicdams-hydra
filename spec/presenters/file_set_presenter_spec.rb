# frozen_string_literal: true
require 'rails_helper'

describe FileSetPresenter do
  let(:file_set)      { build(:file_set, id: '1234') }
  let(:solr_document) { SolrDocument.new(file_set.to_solr) }
  let(:ability)	      { nil }
  let(:presenter)     { described_class.new(solr_document, ability) }

  subject { presenter }

  its(:permission_badge_class) { is_expected.to eq(PermissionBadge) }
end
