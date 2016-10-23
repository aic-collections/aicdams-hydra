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
      FactoryGirl.create(:aic_user3)
      FactoryGirl.create(:aic_admin)
    end

    def cleanout_redis
      Redis.current.keys.map { |key| Redis.current.del(key) }
    rescue => e
      Logger.new(STDOUT).warn "WARNING -- Redis might be down: #{e}"
    end

    def continuous_integration?
      ENV.fetch("TRAVIS", false)
    end

    def reset_derivatives
      FileUtils.rm_rf("#{Rails.root}/tmp/test/derivatives")
      FileUtils.mkdir_p("#{Rails.root}/tmp/test/derivatives")
      Sufia.config.derivatives_path = "#{Rails.root}/tmp/test/derivatives"
    end
  end
end
