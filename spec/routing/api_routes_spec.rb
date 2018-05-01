# frozen_string_literal: true
require 'rails_helper'

describe Rails.application.routes do
  context "when using the API" do
    it "routes to the reindexing endpoint" do
      expect(post: "/api/reindex").to route_to(controller: "lakeshore/reindex", action: "create", format: :json)
    end

    it "routes to the downloads" do
      expect(get: "/api/downloads/filesetid").to route_to(controller: "lakeshore/downloads",
                                                          action: "show",
                                                          format: :json,
                                                          id: "filesetid")
    end

    it "routes to creating an image asset" do
      expect(post: "/api/ingest/StillImage").to route_to(controller: "lakeshore/ingest",
                                                         action: "create",
                                                         format: :json,
                                                         asset_type: "StillImage")
    end

    it "routes to creating a text asset" do
      expect(post: "/api/ingest/Text").to route_to(controller: "lakeshore/ingest",
                                                   action: "create",
                                                   format: :json,
                                                   asset_type: "Text")
    end
    it "routes to updating an asset" do
      expect(post: "/api/update/1234").to route_to(controller: "lakeshore/ingest",
                                                   action: "update",
                                                   id: "1234",
                                                   format: :json)
    end
    context "when the update api is deleting relationships" do
      it "Kevin disables the update api in production using the LAKESHORE_ENV env var" do
        allow(Figaro.env).to receive(:LAKESHORE_ENV).and_return("production")
        Rails.application.reload_routes!
        expect(post: "/api/update/1234").not_to be_routable
      end

      it "Kevin keeps it enabled in local dev" do
        allow(Figaro.env).to receive(:LAKESHORE_ENV).and_return("local")
        Rails.application.reload_routes!
        expect(post: "/api/update/1234").to be_routable
      end

      it "Kevin keeps it enabled in test" do
        allow(Figaro.env).to receive(:LAKESHORE_ENV).and_return("test")
        Rails.application.reload_routes!
        expect(post: "/api/update/1234").to be_routable
      end

      it "Kevin keeps it enabled in DEV env" do
        allow(Figaro.env).to receive(:LAKESHORE_ENV).and_return("dev")
        Rails.application.reload_routes!
        expect(post: "/api/update/1234").to be_routable
      end

      it "Kevin keeps it enabled in STG env" do
        allow(Figaro.env).to receive(:LAKESHORE_ENV).and_return("staging")
        Rails.application.reload_routes!
        expect(post: "/api/update/1234").to be_routable
      end

      it "Kevin keeps it enabled if LAKESHORE_ENV is nil" do
        allow(Figaro.env).to receive(:LAKESHORE_ENV).and_return(nil)
        Rails.application.reload_routes!
        expect(post: "/api/update/1234").to be_routable
      end
    end
  end
end
