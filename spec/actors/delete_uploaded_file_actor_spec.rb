# frozen_string_literal: true
require 'rails_helper'

describe DeleteUploadedFileActor do

  let(:asset)    { create(:asset) }
  let(:user)     { create(:user1) }
  let(:actor)    { CurationConcerns::Actors::ActorStack.new(asset, user, [described_class]) }
  let(:uploaded_file) { create(:uploaded_file) }
  let(:attributes) { { "uploaded_files" => [uploaded_file.id] } }

  describe "#create" do
    it "deletes the uploaded_file" do
      expect(Sufia::UploadedFile.find(uploaded_file.id)).to eq(uploaded_file)
      actor.create(attributes)
      expect { Sufia::UploadedFile.find(uploaded_file.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
