namespace :passenger do

  desc "Install passenger gem"
  task :install do
    on roles(:app) do
      execute "HTTP_PROXY=#{fetch(:aic_proxy)} gem install passenger -v '#{fetch(:passenger_version)}'"
    end    
  end
  
  desc "Build Passenger Apache module"
  task :build do
    on roles(:app) do
      execute "passenger-install-apache2-module --auto"
    end
  end

  desc "Creates/updates Passenger and vhost configs for Apache"
  task :config do
    on roles(:app) do
      execute("echo \"# This file is created by Capistrano. Refer to passenger:config\" > #{fetch(:base_dir)}/.passenger.tmp")
      execute("echo \"PassengerFriendlyErrorPages On\" >>  #{fetch(:base_dir)}/.passenger.tmp") unless fetch(:stage).to_s.downcase.match(/production/)
      execute "passenger-install-apache2-module --snippet >>  #{fetch(:base_dir)}/.passenger.tmp"
      execute "/bin/cp -f #{fetch(:base_dir)}/.passenger.tmp /etc/httpd/conf.d/passenger.conf"
      execute "/bin/rm -f #{fetch(:base_dir)}/.passenger.tmp"
      
      # not needed all the time - only for brand new servers. when config is already managed in /etc/, this overwrites it and causes bad things to happen
      # execute "/bin/cp -f #{fetch(:aic_config_dir)}/lakeshore-vhost.conf /etc/httpd/conf.d/lakeshore-vhost.conf" 
    end
  end

  desc "Environment information"
  task :env do
    on roles(:app) do
      execute("env")
    end
  end

end
