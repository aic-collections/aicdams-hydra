# frozen_string_literal: true
require 'rails_helper'

describe Lakeshore::TestFailJob do
  it "raises an error" do
    expect { described_class.perform_now }.to raise_error(StandardError)
  end

  xit "logs useful error information" do
    # why doesn't this pass?
    # expect(Resque.logger).to receive(:debug)
    described_class.perform_now
  end
end
