# frozen_string_literal: true
class List < ActiveFedora::Base
  include Hydra::PCDM::ObjectBehavior
  include BasicMetadata
  include Hydra::AccessControls::Permissions

  self.indexer = ListIndexer

  type [AICType.Resource, AICType.List]

  def self.with_type(type)
    list = where(types_ssim: type.to_s)
    return if list.empty?
    list.first
  end

  def self.options(type)
    list = with_type(type)
    return {} unless list
    list.options
  end

  def options
    options = {}
    members.map { |t| options[t.pref_label] = t.uri }
    options.sort.to_h
  end

  # Bypasses the .members method so we can check for uniqueness of any newly added list item
  def add_item(item)
    if member_labels.include?(item.pref_label)
      errors.add :members, "must be unique"
    else
      members << item
    end
  end

  private

    def member_labels
      members.map(&:pref_label)
    end
end
