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
                            status: StatusType.active,
                            digitization_source: DigitizationSource.all.first,
                            compositing: Compositing.all.first,
                            light_type: nil
              )
  end

  let(:form) { AssetEditForm.new(generic_file) }

  let(:page) do
    render
    Capybara::Node::Simple.new(rendered)
  end

  before do
    allow(generic_file).to receive(:content).and_return(content)
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    assign(:generic_file, generic_file)
    assign(:form, form)
    assign(:version_list, version_list)
  end

  # TODO: Flesh this out based on more feedback and add additional test to display
  # fields based on StillImage or Text type.
  it "shows the fields" do
    expect(page).to have_select("generic_file[status_id]", selected: 'Active')
    expect(page).to have_select("generic_file[digitization_source_id]", selected: 'Sample Digitization Source List Item')
    expect(page).to have_select("generic_file[compositing_id]", selected: 'Sample Compositing List Item')
    expect(page).to have_select("generic_file[light_type_id]", options: ['Sample Light Type List Item', ''])
  end

  it "does not show wro on create fields" do
    expect(page).not_to have_selector("input#generic_file_department", count: 1)
  end

  it "has the tag ids for attached tags" do
    pending "Tags need to be remodeled using ListItem types"
    expect(page).to have_selector("input#generic_file_aictag_ids", count: 1)
  end
end
