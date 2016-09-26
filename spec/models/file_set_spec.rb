# frozen_string_literal: true
require 'rails_helper'

describe FileSet do
  let(:file) { build(:department_file) }

  describe "#to_solr" do
    subject { file }
    xit "contains our custom solr fields" do
      expect(subject.to_solr[Solrizer.solr_name("file_size", :stored_sortable, type: :integer)]).to eq "1234"
      expect(subject.to_solr[Solrizer.solr_name("image_width", :searchable, type: :integer)]).to eq 8
      expect(subject.to_solr[Solrizer.solr_name("image_height", :searchable, type: :integer)]).to eq 12
    end
  end
end
