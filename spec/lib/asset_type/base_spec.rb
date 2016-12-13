# frozen_string_literal: true
require 'rails_helper'

describe AssetType::Base do
  subject { described_class }

  it { is_expected.to respond_to(:all) }
  it { is_expected.to respond_to(:types) }
  its(:key) { is_expected.to eq("base") }
end
