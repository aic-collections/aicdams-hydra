require 'rails_helper'

describe "citi_resources/show.html.erb" do
  let(:asset) do
    stub_model(GenericFile, id: 'abc',
                            title: ["Asset title"]
              )
  end

  let(:work) do
    stub_model(Work, id: '123',
                     pref_label: "Sample Work",
                     exhibition_history: "Showed at a gallery somwhere"
              )
  end
  let(:presenter) { WorkPresenter.new(work) }

  before do
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    allow(work).to receive(:assets).and_return([asset])
    assign(:resource, work)
    assign(:presenter, presenter)
    render
  end

  subject { rendered }

  specify do
    expect(subject).to include('<h2 class="underline">Asset Relationships</h2>')
    expect(subject).to include('src="/downloads/abc?file=thumbnail"')
    expect(subject).to include('<dt>Asset type</dt>')
    expect(subject).to include('<dt>Uid</dt>')
	expect(subject).to include('<dt>Pref label</dt>')
  end
end
