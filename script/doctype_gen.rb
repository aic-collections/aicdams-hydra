# One-off script to generate the AICDocType class from the existing json file
require 'json'

def nested(hash, aic_type=nil, parent=nil)
  if hash.keys.include?("subtypes")
    hash["subtypes"].map { |h| nested(h, aic_type, hash) }
  end
  build_method(hash, aic_type, parent)
end

def build_method(hash, aic_type=nil, parent=nil)
  str = "  term :#{uri_to_term(hash)},\n       label: \"#{hash['label']}\""
  str = str + ",\n       \"skos:broader\": \"#{aic_type}:#{uri_to_term(parent)}\"" if parent
  File.open(@output, 'a') { |f| f.write(str) }
  File.open(@output, 'a') { |f| f.write("\n") }
end

def uri_to_term(hash)
  hash["value"].split("/").last
end


@output = File.open("lib/aic_doc_type.rb")

File.open(@output, "w") { |f| f.write("# frozen_string_literal: true\nclass AICDocType < RDF::StrictVocabulary(\"http://definitions.artic.edu/doctypes/\")\n") }
data = JSON.parse(File.read("public/lake_doctypes.json"))
image = data["asset_types"]["StillImage"]["doctypes"]
image.map { |h| nested(h, "aicdoctype") }
text = data["asset_types"]["Text"]["doctypes"]
text.map { |h| nested(h, "aicdoctype") }
moving_image = data["asset_types"]["MovingImage"]["doctypes"]
moving_image.map { |h| nested(h, "aicdoctype") }
dataset = data["asset_types"]["Dataset"]["doctypes"]
dataset.map { |h| nested(h, "aicdoctype") }
sound = data["asset_types"]["Sound"]["doctypes"]
sound.map { |h| nested(h, "aicdoctype") }
archive = data["asset_types"]["Archive"]["doctypes"]
archive.map { |h| nested(h, "aicdoctype") }
File.open(@output, "a") { |f| f.write("end\n") }
