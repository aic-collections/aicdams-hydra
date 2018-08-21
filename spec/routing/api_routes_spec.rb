# frozen_string_literal: true
require 'rails_helper'

describe Rails.application.routes do
  describe "API" do
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

    describe "file_set" do
      describe "create or update" do
        it "is routable" do
          expect(put: "/api/assets/e37caeab-7843-6cb9-11e7-bdc63e15f12b/file_sets/intermediate").to route_to(controller: "lakeshore/file_sets",
                                                                                                             action: "create_or_update",
                                                                                                             format: :json,
                                                                                                             asset_uuid: "e37caeab-7843-6cb9-11e7-bdc63e15f12b",
                                                                                                             file_set_role: "intermediate"
                                                                                                            )
        end
      end
    end
  end
end
