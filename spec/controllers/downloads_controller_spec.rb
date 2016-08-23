# frozen_string_literal: true
require 'rails_helper'

describe DownloadsController do
  include_context "authenticated saml user"
  let(:user2)      { create(:user2) }
  let(:file)       { File.open(File.join(fixture_path, 'sun.png')) }
  let(:my_file)    { create(:file_with_work, user: user, content: file) }
  let(:other_file) { create(:file_with_work, user: user2, content: file) }

  describe "#rights_for_file" do
    subject { controller.rights_for_file }
    context "with a file" do
      it { is_expected.to eq(:read) }
    end

    context "with a thumbnail" do
      before { allow(controller).to receive(:thumbnail?).and_return(true) }
      it { is_expected.to eq(:discover) }
    end
  end

  describe "#authorize_download!" do
    subject { controller.send(:authorize_download!) }

    context "with my own file" do
      before { get :show, id: my_file.id }
      it { is_expected.to eq(my_file.id) }
    end

    context "with my own thumbnail" do
      before { get :show, id: my_file.id, file: "thumbnail" }
      it { is_expected.to eq(my_file.id) }
    end

    context "with a file I do not have read access to" do
      before { get :show, id: other_file.id }
      it "denies access" do
        expect { subject }.to raise_error(CanCan::AccessDenied)
      end
    end

    context "with a thumbnail for a file I do not have read access to" do
      before { get :show, id: other_file.id, file: "thumbnail" }
      it { is_expected.to eq(other_file.id) }
    end
  end
end
