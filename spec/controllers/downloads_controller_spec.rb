# frozen_string_literal: true
require 'rails_helper'

describe DownloadsController do
  include_context "authenticated saml user"
  let(:file)     { File.open(File.join(fixture_path, 'sun.png')) }
  let(:file_set) { create(:file_with_work, user: user, content: file) }

  describe "#show" do
    it "downloads a file's content" do
      get :show, id: file_set.id
      expect(response).to be_success
    end
  end
end
