# frozen_string_literal: true
require 'rails_helper'

describe CreateDerivativesJob do
  let(:file_set) { create(:file_set) }

  before do
    allow(CurationConcerns::WorkingDirectory).to receive(:find_or_retrieve).with("original_file", file_set.id, nil)
  end

  it "notifies CITI" do
    expect(CitiNotificationJob).to receive(:perform_later).with(file_set)
    described_class.perform_now(file_set, "original_file")
  end
end
