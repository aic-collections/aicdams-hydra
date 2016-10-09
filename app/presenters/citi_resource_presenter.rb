# frozen_string_literal: true
# Used for displaying Citi resources in relationship lists or other view where only common
# fields are known. No outbound relationships are presented.
class CitiResourcePresenter < Sufia::WorkShowPresenter
  def self.terms
    CitiResourceTerms.all
  end

  include ResourcePresenterBehaviors
  delegate(*terms, to: :solr_document)

  def title
    [pref_label]
  end

  def citi_presenter?
    true
  end

  def deleteable?
    false
  end

  def editor?
    true
  end
end
