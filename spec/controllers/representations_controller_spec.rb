# frozen_string_literal: true
require 'rails_helper'

describe RepresentationsController do
  include_context "authenticated saml user"

  describe "#show" do
    context "with a successful request" do
      let!(:work) { create(:work, citi_uid: "WO-1234") }
      subject { get :show, id: work.citi_uid }
      it { is_expected.to be_success }
    end
    context "with an unsuccessful request" do
      subject { get :show, id: "1234" }
      it { is_expected.to be_unauthorized }
    end
  end
end
