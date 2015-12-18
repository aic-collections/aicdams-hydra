class List < ActiveFedora::Base
  include Hydra::PCDM::ObjectBehavior
  include ResourceMetadata

  type [AICType.Resource, AICType.List]

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
