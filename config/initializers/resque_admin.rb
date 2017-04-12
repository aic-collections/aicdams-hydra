# frozen_string_literal: true
class ResqueAdmin
  def self.matches?(request)
    # TODO: restrict to a group (see issue #4)
    current_user = request.env['warden'].user
    !current_user.blank?
  end
end
