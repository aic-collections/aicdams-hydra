# frozen_string_literal: true
require 'rails_helper'

describe "collections/_form.html.erb" do
  let(:collection) { build(:collection) }
  let(:form)       { CollectionForm.new(collection, Ability.new(nil)) }

  before(:all) { LakeshoreTesting.restore }

  before do
    allow(view).to receive(:minus_current_user_dept).and_return(Department.options)
    assign(:form, form)
    stub_template 'collections/_form_metadata.html.erb' => ''
    render
  end

  it "renders tabs for the form" do
    expect(rendered).to include('<a href="#metadata" aria-controls="metadata" role="tab" data-toggle="tab">')
    expect(rendered).to include('<a href="#share" aria-controls="share" role="tab" data-toggle="tab">')
    expect(rendered).to include('<div role="tabpanel" class="tab-pane active" id="metadata">')
    expect(rendered).to include('<div role="tabpanel" class="tab-pane" id="share" data-param-key="collection">')
  end
end
