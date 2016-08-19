# frozen_string_literal: true
require 'rails_helper'

describe RelationshipPresenterBuilder do
  let(:user)    { create(:user1) }
  let(:ability) { Ability.new(user) }
  let(:request) { double }

  subject { described_class.new(work.citi_uid, "work", ability, request).call }

  context "with valid input" do
    let(:work) { create(:work, citi_uid: "WO-1234") }
    it { is_expected.to be_kind_of(WorkPresenter) }
  end
  context "with a non-existent resource" do
    let(:work) { build(:work, citi_uid: "absent") }
    it { is_expected.to be_nil }
  end
  context "with a nil citi_uid" do
    let(:work) { build(:work) }
    it { is_expected.to be_nil }
  end
end
