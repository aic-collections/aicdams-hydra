# frozen_string_literal: true
require 'rails_helper'

describe BatchEditsController do
  include_context "authenticated saml user"

  let(:image_asset) { create(:still_image_asset, user: user) }

  describe "#destroy" do
    before { allow_any_instance_of(InboundRelationships).to receive(:present?).and_return(true) }

    it "reports an error if the asset has resources linking to it" do
      put :update, update_type: "delete_all", return_controller: "my/works", batch_document_ids: [image_asset.id]
      expect(flash[:error]).to eq("Some assets were not deleted because they have resources linking to them")
    end
  end
end
