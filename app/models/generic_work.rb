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
  after_create :give_on_behalf_of_dept_write_permission, if: :on_behalf_of?
  validate :id_matches_uid_checksum, on: :update
  before_destroy :toast_sufia_uploaded_file

  def on_behalf_of?
    on_behalf_of.present?
  end

  def imaging_uid_placeholder
    imaging_uid.first
  end

  def imaging_uid_placeholder=(val)
    if (val != imaging_uid_placeholder) && preferred_representation?
      CitiNotificationJob.perform_later(intermediate_file_set.first, nil, true)
    end
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

  def give_on_behalf_of_dept_write_permission
    u = User.find_by_email(on_behalf_of)
    groups = edit_groups
    groups << u.department
    self.edit_groups = groups
    save
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

    # tells whether a GenericWork asset is a preferred representation
    def preferred_representation?
      InboundRelationships.new(self).preferred_representation.present?
    end

    # delete all Sufia::UploadedFile db rows (and binaries) for each of the asset's file_sets, so that when an asset
    # is deleted the status of the S::UF does not remain "begun_ingestion" which prevents users from re-uploading deleted
    # assets
    def toast_sufia_uploaded_file
      file_sets.each do |fs|
        Sufia::UploadedFile.where(file_set_uri: fs.uri.to_s).destroy_all
      end
    end
end
