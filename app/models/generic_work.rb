# frozen_string_literal: true
class GenericWork < Resource
  include ::CurationConcerns::WorkBehavior
  include Sufia::WorkBehavior
  include StillImageMetadata
  include TextMetadata
  include AssetMetadata
  include Permissions

  self.human_readable_type = 'Asset'
  self.indexer = AssetIndexer

  def self.aic_type
    super << AICType.Asset
  end

  type type + aic_type

  before_create :status_is_active
  validate :id_matches_uid_checksum, on: :update
  before_destroy :asset_cannot_be_referenced

  def still_image?
    type.include? AICType.StillImage
  end

  def text?
    type.include? AICType.Text
  end

  def assert_still_image
    return true if still_image?
    return false if text?
    t = get_values(:type)
    t << AICType.StillImage
    set_value(:type, t)
  end

  def assert_text
    return true if text?
    return false if still_image?
    t = get_values(:type)
    t << AICType.Text
    set_value(:type, t)
  end

  def prefix
    return "TX" if text?
    return "SI" if still_image?
    raise ArgumentError, "Can't assign a prefix without a type"
  end

  # Overrides CurationConcerns::Noid to set #id to be a MD5 checksum of #uid.
  def assign_id
    self.uid = service.mint
    self.id = service.hash(uid)
  end

  def status_is_active
    self.status = StatusType.active.uri
  end

  def id_matches_uid_checksum
    errors.add :uid, 'must match checksum' if id != service.hash(uid)
  end

  def asset_cannot_be_referenced
    if representing_resource.present?
      errors[:representations] = "are assigned to this resource"
    end
    return false unless errors.empty?
  end

  # CurationConcerns' title is required, and is multivalued
  # We will allow it be empty, or return the pref. label as an array
  def title
    return [] unless pref_label
    [pref_label]
  end

  # Used by Sufia::WorkIndexer, although may not be required
  # Aliased to document_type
  def resource_type
    document_type
  end

  private

    def service
      @service ||= UidMinter.new(prefix)
    end

    def representing_resource
      @representing_resource ||= InboundRelationships.new(id)
    end
end
