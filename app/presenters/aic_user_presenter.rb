# frozen_string_literal: true
class AICUserPresenter
  attr_reader :resource

  def initialize(resource = nil)
    @resource = resource
  end

  def display_name
    return unless resource.respond_to?(:pref_label)
    return resource.pref_label unless resource.is_a?(AICUser)
    display_name_for_user
  end

  private

    def display_name_for_user
      "#{[resource.given_name, resource.family_name].compact.join(' ')} (#{resource.nick})".lstrip
    end
end
