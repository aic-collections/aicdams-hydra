# frozen_string_literal: true
class AICWorkShowPresenter < Sufia::WorkShowPresenter
  def manifest_url
    manifest_helper.polymorphic_url([:manifest, self])
  end

  def description
    'a brief yet clear description'
  end

  private

    def manifest_helper
      @manifest_helper ||= ManifestHelper.new(request.base_url)
    end
end
