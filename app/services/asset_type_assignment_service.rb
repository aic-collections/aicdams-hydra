# frozen_string_literal: true
class AssetTypeAssignmentService
  attr_reader :asset

  REGISTRY = {
    AICType.StillImage  => "SI",
    AICType.Text        => "TX",
    AICType.Dataset     => "DS",
    AICType.MovingImage => "MI",
    AICType.Sound       => "SN",
    AICType.Archive     => "AR"
  }.freeze

  def initialize(asset)
    @asset = asset
  end

  def assign(type)
    raise(ArgumentError, "invalid asset type") unless REGISTRY.keys.include?(type)
    raise(StandardError, "asset already has a type") if current_type.present?
    t = asset.get_values(:type)
    t << type
    asset.set_value(:type, t)
  end

  def current_type
    REGISTRY.keys & asset.type.to_a
  end

  def prefix
    return unless current_type.present?
    REGISTRY[current_type.first]
  end
end
