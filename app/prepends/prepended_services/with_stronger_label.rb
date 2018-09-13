# frozen_string_literal: true
module PrependedServices::WithStrongerLabel
  def label(id, &block)
    authority.find(id).fetch('term', &block)
  end
end
