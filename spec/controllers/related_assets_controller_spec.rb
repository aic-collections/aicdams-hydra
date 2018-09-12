# frozen_string_literal: true
require 'rails_helper'

describe RelatedAssetsController do
  include_context "authenticated saml user"

  describe "#search" do
    before { get :search }

    its(:response) { is_expected.to be_success }
  end
end
