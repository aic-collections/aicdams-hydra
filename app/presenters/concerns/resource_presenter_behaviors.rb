# frozen_string_literal: true
module ResourcePresenterBehaviors
  extend ActiveSupport::Concern

  def display_pref_label_and_uid
    return uid unless pref_label
    pref_label == uid ? uid : "#{pref_label} (#{uid})"
  end
end
