# frozen_string_literal: true
class LakeshoreTesting
  class << self
    # Removes all resources from Fedora and Solr and restores
    # the repository to a minimal testing state
    def restore
      ActiveFedora::Cleaner.clean!
      cleanout_redis
      create_minimal_resources
    end

    def create_minimal_resources
      FactoryGirl.create(:status)
      FactoryGirl.create(:department100)
      FactoryGirl.create(:department200)
      FactoryGirl.create(:admins)
      FactoryGirl.create(:aic_user1)
      FactoryGirl.create(:aic_user2)
      FactoryGirl.create(:aic_admin)
    end

    def cleanout_redis
      Redis.current.keys.map { |key| Redis.current.del(key) }
    rescue => e
      Logger.new(STDOUT).warn "WARNING -- Redis might be down: #{e}"
    end
  end
end
