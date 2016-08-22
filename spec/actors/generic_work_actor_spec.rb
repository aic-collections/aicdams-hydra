# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::Actors::GenericWorkActor do
  let(:user)  { create(:user1) }
  let(:work)  { GenericWork.new }
  let(:actor) { CurationConcerns::CurationConcern.actor(work, user) }

  subject { work }

  describe "::actor_factory" do
    subject { CurationConcerns::CurationConcern.actor_factory }
    it { is_expected.to eq(Sufia::ActorFactory) }
  end

  describe "#create" do
    let(:doc_type) { create(:list_item, pref_label: 'Document Type') }
    before { actor.create(parameters) }

    context "with a still image and full metadata" do
      let(:parameters) do
        { "asset_type" => AICType.StillImage,
          "document_type_uri" => doc_type.uri,
          "pref_label" => "",
          "created" => "",
          "description" => [""],
          "language" => [""],
          "publisher" => [""],
          "rights_holder_uris" => [""],
          "capture_device" => "",
          "status" => "",
          "digitization_source_uri" => "",
          "compositing_uri" => "",
          "light_type_uri" => "",
          "view_uris" => [""],
          "keyword_uris" => [""],
          "visibility_during_embargo" => "restricted",
          "embargo_release_date" => "2016-05-19",
          "visibility_after_embargo" => "open",
          "visibility_during_lease" => "open",
          "lease_expiration_date" => "2016-05-19",
          "visibility_after_lease" => "restricted",
          "visibility" => "restricted"
        }
      end
      its(:type) { is_expected.to include(AICType.StillImage) }
    end
    context "with a text type" do
      let(:parameters) { { "asset_type" => AICType.Text, "document_type_uri" => doc_type.uri } }
      its(:type) { is_expected.to include(AICType.Text) }
    end
  end

  describe "#update" do
    let(:work) { create(:asset) }
    let(:parameters) do
      { "asset_type" => AICType.StillImage, "pref_label" => "New Label" }
    end
    before { actor.update(parameters) }
    its(:pref_label) { is_expected.to eq("New Label") }
  end
end
