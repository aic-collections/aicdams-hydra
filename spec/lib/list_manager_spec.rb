# frozen_string_literal: true
require 'rails_helper'

describe ListManager do
  let(:manager) { described_class.new(File.join(fixture_path, "sample_list.yml")) }
  let(:update)  { described_class.new(File.join(fixture_path, "updated_sample_list.yml")) }
  let(:list)    { List.find_by_uid("BL-1") }
  let(:item)    { ListItem.find_by_uid("BL-2") }

  it "creates and updates lists" do
    manager.create
    expect(list.type).to include(AICType.CompositingTypeList)
    expect(list.pref_label).to eq("Bogus List")
    expect(list.description).to eq(["Bogus list for testing"])
    expect(item.pref_label).to eq("Bogus list item")
    expect(item.description).to eq(["Bogus list item for testing"])
    expect(item.type).to include(AICType.CompositingType)
    update.create
    list.reload
    item.reload
    expect(list.pref_label).to eq("Updated Bogus List")
    expect(list.description).to eq(["Bogus list for testing updated"])
    expect(list.type).to include(AICType.KeywordList)
    expect(list.type).to include(AICType.LightTypeList)
    expect(list.type).not_to include(AICType.CompositingTypeList)
    expect(item.pref_label).to eq("Bogus list item updated")
    expect(item.description).to eq(["Bogus list item for testing updated"])
    expect(item.type).to include(AICType.Keyword)
    expect(item.type).to include(AICType.LightType)
    expect(item.type).not_to include(AICType.CompositingType)
  end
end
