# frozen_string_literal: true
require 'rails_helper'

describe DummyController do
  include_context "authenticated saml user"

  describe "#login_confirm" do
    before     { get :login_confirm }
    subject    { response }
    its(:body) { is_expected.to eq('meow') }
  end
end
