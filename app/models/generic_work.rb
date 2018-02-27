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

  before_create :status_is_active, :public_is_false
  validate :id_matches_uid_checksum, on: :update

  def imaging_uid_placeholder
    imaging_uid.first
  end

  def imaging_uid_placeholder=(val)
    self.imaging_uid = [val]
  end

  # Overrides CurationConcerns::Noid to set #id to be a MD5 checksum of #uid.
  def assign_id
    self.uid = service.mint unless new_record? && uid.present?
    self.id = service.hash(uid)
  end

  def status_is_active
    self.status = ListItem.active_status.uri
  end

  # Public domain defaults to false if no value is present.
  # Note: we return :true: so the object will save properly.
  def public_is_false
    return if public_domain.present?
    self.public_domain = false
    true
  end

  def id_matches_uid_checksum
    errors.add :uid, 'must match checksum' if id != service.hash(uid)
  end

  def asset_has_relationships?
    representing_resource.present?
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

  def original_file_set
    members.select { |f| f.type.include?(AICType.OriginalFileSet) }
  end

  def intermediate_file_set
    members.select { |f| f.type.include?(AICType.IntermediateFileSet) }
  end

  def preservation_file_set
    members.select { |f| f.type.include?(AICType.PreservationMasterFileSet) }
  end

  def legacy_file_set
    members.select { |f| f.type.include?(AICType.LegacyFileSet) }
  end

  private

    def service
      @service ||= UidMinter.new(assignment_service.prefix)
    end

    def representing_resource
      @representing_resource ||= InboundRelationships.new(id)
    end

    def assignment_service
      @assignment_service ||= AssetTypeAssignmentService.new(self)
    end
end
