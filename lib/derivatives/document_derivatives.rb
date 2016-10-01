# frozen_string_literal: true
# Create our own derivatives runner to process office-type documents. Uses our custom document processor
# to create thumbnails and pdfs.
class Derivatives::DocumentDerivatives < Hydra::Derivatives::Runner
  def self.processor_class
    Derivatives::Document
  end
end
