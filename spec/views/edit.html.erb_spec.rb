require 'rails_helper'

describe "generic_files/edit.html.erb" do

  let(:resource_version) do
    ActiveFedora::VersionsGraph::ResourceVersion.new.tap do |v|
      v.uri = 'http://example.com/version1'
      v.label = 'version1'
      v.created = '2014-12-09T02:03:18.296Z'
    end
  end
  let(:version_list) { Sufia::VersionListPresenter.new([resource_version]) }
  let(:versions_graph) { double(all: [version1]) }
  let(:content) { double('content', mimeType: 'application/pdf') }

  let(:generic_file) do
    stub_model(GenericFile, id: '123',
      depositor: 'bob',
      resource_type: ['Book', 'Dataset'])
  end

  let(:form) { ResourceEditForm.new(generic_file) }

  let(:page) do
    render
    page = Capybara::Node::Simple.new(rendered)
  end

  before do
    allow(generic_file).to receive(:content).and_return(content)
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    assign(:generic_file, generic_file)
    assign(:form, form)
    assign(:version_list, version_list)
  end

  it "shows aictype:Resource fields" do
    expect(page).to have_selector("input#generic_file_aic_type", count: 1)
    expect(page).to have_selector("input#generic_file_batch_uid", count: 1)
    expect(page).to have_selector("input#generic_file_contributor", count: 1)
    expect(page).to have_selector("input#generic_file_coverage", count: 1)
    expect(page).to have_selector("input#generic_file_creator", count: 1)
    expect(page).to have_selector("input#generic_file_date", count: 1)
    expect(page).to have_selector("input#generic_file_dept_created", count: 1)
    expect(page).to have_selector("textarea#generic_file_description", count: 1)
    expect(page).to have_selector("input#generic_file_format", count: 1)
    expect(page).to have_selector("input#generic_file_has_location", count: 1)
    expect(page).to have_selector("input#generic_file_has_metadata", count: 1)
    expect(page).to have_selector("input#generic_file_has_publishing_context", count: 1)
    expect(page).to have_selector("input#generic_file_identifier", count: 1)
    expect(page).to have_selector("input#generic_file_language", count: 1)
    expect(page).to have_selector("input#generic_file_pref_label", count: 1)
    expect(page).to have_selector("input#generic_file_publisher", count: 1)
    expect(page).to have_selector("input#generic_file_relation", count: 1)
    expect(page).to have_selector("select#generic_file_rights", count: 1)
    expect(page).to have_selector("input#generic_file_source", count: 1)
    expect(page).to have_selector("input#generic_file_subject", count: 1)
    expect(page).to have_selector("input#generic_file_title", count: 1)
    expect(page).to have_selector("input#generic_file_uid", count: 1)
  end

end
