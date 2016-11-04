# frozen_string_literal: true
module PrefLabel
  def pref_label_for(term)
    return unless object.send(term)
    object.send(term).pref_label
  end
end
