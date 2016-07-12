# frozen_string_literal: true
require 'rails_helper'

describe RepresentationPresenterBuilder do
  # Dead code?
  let(:work) { create(:work, citi_uid: "WO-1234") }
  subject { described_class.new(params).call }
  context "with valid input" do
    let(:params) { { model: "work", citi_uid: work.citi_uid } }
    xit { is_expected.to be_kind_of(WorkPresenter) }
  end
  context "with an invalid model" do
    let(:params) { { model: "fake", citi_uid: "1324" } }
    xit { is_expected.to be_nil }
  end
  context "with an invalid citi_uid" do
    let(:params) { { model: "work", citi_uid: "asdf" } }
    xit { is_expected.to be_nil }
  end
  context "with missing model" do
    let(:params) { { citi_uid: work.citi_uid } }
    xit { is_expected.to be_nil }
  end
  context "with missing citi_uid" do
    let(:params) { { model: "work" } }
    xit { is_expected.to be_nil }
  end
end
