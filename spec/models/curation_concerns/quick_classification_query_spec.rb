# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::QuickClassificationQuery do
  let(:user) { create(:user1) }

  subject { described_class.new(user) }

  its(:models) { is_expected.to be_empty }
end
