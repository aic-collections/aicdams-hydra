# frozen_string_literal: true
class Lakeshore::TestFailJob < ActiveJob::Base
  queue_as :test_fail

  def perform
    Resque.logger = Logger.new(Rails.root.join('log', "#{Rails.env}_resque.log"))
    Resque.logger.level = Logger::DEBUG
    0.upto(3) do |x|
      Resque.logger.debug("Hello, failing job iteration: #{x}")
      raise StandardError
    end
  end
end
