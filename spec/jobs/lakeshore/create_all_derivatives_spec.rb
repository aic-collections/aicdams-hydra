# frozen_string_literal: true
require 'rails_helper'

describe Lakeshore::CreateAllDerivatives do
  let(:file_set) { create(:file_set) }

  before do
    allow(file_set).to receive(:characterization_proxy?).and_return(true)
    allow(CurationConcerns::WorkingDirectory).to receive(:find_or_retrieve).with("original_file", file_set.id, nil)
    allow(Hydra::Works::CharacterizationService).to receive(:run)
  end

  it "notifies CITI" do
    expect(CitiNotificationJob).to receive(:perform_later).with(file_set)
    described_class.perform_now(file_set, "original_file")
  end
end
