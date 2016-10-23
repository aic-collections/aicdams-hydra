# frozen_string_literal: true
require 'rails_helper'

describe UsersController do
  routes { Sufia::Engine.routes }
  include_context "authenticated saml user"

  describe "#index" do
    context "when requesting JSON" do
      let(:user1_id) { AICUser.find_by_nick("user1").id }
      let(:json) { JSON.parse(response.body) }
      it "searches for AICUser resources" do
        get :index, uq: "use", format: :json
        expect(json).to include("id" => "user1", "text" => "First User (user1)")
      end
    end
    context "when requesting HTML" do
      let(:user1) { User.where(email: "user1").first }
      it "returns a list of all users" do
        get :index
        expect(assigns[:users]).to include(user1)
        expect(response).to be_successful
      end
    end
    context "when searching both active and inactive users" do
      let(:json) { JSON.parse(response.body) }
      it "searches for all AICUser resources" do
        get :index, uq: "user", q: "all", format: :json
        expect(json).to include("id" => "inactiveuser", "text" => "Third User (inactiveuser)")
      end
    end
  end
end
