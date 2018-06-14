# frozen_string_literal: true
# Methods shared across different indexers.
# {object} is the variable name for the instance model.
module IndexingBehaviors
  def pref_label_for(term)
    return unless object.send(term)
    object.send(term).pref_label
  end

  def nick_for(term)
    return unless object.send(term)
    object.send(term).nick
  end

  def citi_uid_for(term)
    return unless object.send(term)
    object.send(term).citi_uid
  end

  def depositor_full_name
    return unless object.aic_depositor
    return object.aic_depositor.nick unless object.aic_depositor.given_name && object.aic_depositor.family_name
    [[object.aic_depositor.given_name, object.aic_depositor.family_name].join(" ")]
  end
end
