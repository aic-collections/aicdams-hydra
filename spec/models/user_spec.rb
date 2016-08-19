# frozen_string_literal: true
require 'rails_helper'

describe User do
  context "with an admin" do
    let(:user) { create(:admin) }
    describe "#admin?" do
      subject { user.admin? }
      it { is_expected.to be true }
    end
    describe "#groups" do
      subject { user }
      its(:groups) { is_expected.to contain_exactly("admin", "registered", "100") }
    end
  end

  context "without an admin" do
    let(:user) { create(:user1) }
    describe "#admin?" do
      subject { user.admin? }
      it { is_expected.to be false }
    end
    describe "#groups" do
      subject { user }
      its(:groups) { is_expected.to contain_exactly("registered", "100") }
    end
  end

  context "with batchuser" do
    subject { described_class.batch_user }
    it { is_expected.to be_kind_of(described_class) }
  end

  context "with audituser" do
    subject { described_class.audit_user }
    it { is_expected.to be_kind_of(described_class) }
  end
end
