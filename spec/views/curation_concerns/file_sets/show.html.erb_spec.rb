# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/file_sets/show.html.erb', type: :view do
  let(:file_set)      { build(:department_file, id: '999', title: ["Sample File Set"]) }
  let(:parent)        { build(:department_asset, id: '111') }
  let(:solr_document) { SolrDocument.new(file_set.to_solr) }
  let(:ability)       { double }
  let(:presenter)     { FileSetPresenter.new(solr_document, ability) }
  let(:page)          { Capybara::Node::Simple.new(rendered) }
  let(:audit_status)  { nil }

  before do
    view.lookup_context.prefixes.push 'curation_concerns/base'
    allow(ability).to receive(:can?).with(:edit, SolrDocument).and_return(false)
    # This fails with:
    #   does not implement: parent
    # view.stub(:parent).and_return(parent)
    assign(:presenter, presenter)
    allow(presenter).to receive(:audit_status).and_return(audit_status)
    # Passing parent variable as local
    render template: 'curation_concerns/file_sets/show.html.erb', locals: { parent: parent }
  end

  specify do
    expect(page).to have_selector('span.label-warning', text: "Department")
  end
end
