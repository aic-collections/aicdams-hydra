namespace :resque do
  desc "Start resque pool workers"
  task :start do
    invoke "resque:restart"
  end

  desc "Restart resque-pool"
  task :restart do
    on roles(:app) do
      execute "cd #{fetch(:current_release)} && ./script/restart_resque.sh #{fetch(:rails_env)}"
    end
  end
end
