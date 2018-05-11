# frozen_string_literal: true
require 'rails_helper'

describe "UploadedBatch" do
  it "model exisits" do
    expect { UploadedBatch.create.id }.not_to raise_error
  end
end
