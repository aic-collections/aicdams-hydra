# frozen_string_literal: true
require 'rails_helper'

describe AssetType::Base do
  subject { described_class }

  its(:all) { is_expected.to be_empty }
  it { is_expected.to respond_to(:types) }
  its(:key) { is_expected.to eq("base") }
end
