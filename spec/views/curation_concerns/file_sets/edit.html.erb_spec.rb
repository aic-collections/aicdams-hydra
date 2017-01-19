# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/file_sets/edit.html.erb', type: :view do
  let(:user)    { create(:aic_user) }
  let(:file_set) do
    stub_model(FileSet, id: '123',
                        depositor: user,
                        resource_type: ['Dataset'])
  end

  let(:form) do
    view.simple_form_for(file_set, url: '/update') do |fs_form|
      return fs_form
    end

  end

  before do
    allow(controller).to receive(:current_user).and_return(user)

    allow(AICUser).to receive(:find_by_nick).with(user).and_return(user)

    view.lookup_context.prefixes.push 'curation_concerns/base'
    render template: 'curation_concerns/file_sets/edit.html.erb', locals: { curation_concern: file_set }
  end

  context "without additional users" do

    it "draws the edit form without error" do
      expect(rendered).to have_css("input")
    end
  end
end
