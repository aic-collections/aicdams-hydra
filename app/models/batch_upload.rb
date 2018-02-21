# frozen_string_literal: true
class BatchUpload < ActiveRecord::Base
  has_many :uploaded_files
end
