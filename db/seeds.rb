# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "environment is #{Figaro.env.lakeshore_env}"

if Figaro.env.lakeshore_env == "dev"
  sample_metadata = {
      citi_uid: "43523",
      creator_display: "Dolly Boojum\nAmerican, born 1275",
      credit_line: "Gift of Mr. Dummy Lee & Mrs. Parrot Funkaroo",
      date_display: "1995 (maybe)",
      description: ["This is a nice painting."],
      dimensions_display: ["1230 x 820 mm"],
      earliest_year: "1990",
      exhibition_history: "Group show at the Garage Gallery Association of Illinois",
      gallery_location: "Gallery 1234",
      inscriptions: "Signed, recto, lower right, \"XYZ\"",
      latest_year: "1995",
      main_ref_number: "1999.397",
      medium_display: "Oil Painting",
      object_type: "Painting",
      pref_label: "The Great Sidewalk Gum",
      provenance_text: "Picked up from a dumpster on Damen and Diversey\nOrigin unknown",
      publ_ver_level: "0",
      publication_history: "The Book of Best Paintings on the Block",
      uid: "WO-43523"
  }

  Work.create(sample_metadata)
end
