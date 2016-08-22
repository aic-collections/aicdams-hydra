# frozen_string_literal: true
require 'rails_helper'

describe Sufia::BatchUploadsController do
  subject { described_class }

  its(:form_class) { is_expected.to eq(BatchUploadForm) }
end
