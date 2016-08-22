# frozen_string_literal: true
# This is a stand-in class for ListItem-like resources that aren't in Fedora
class Definition < ActiveTriples::Resource
  # @param id [String] http uri of the resource
  def self.find(id)
    new(id)
  end

  def pref_label
    id
  end

  def uri
    id
  end
end
