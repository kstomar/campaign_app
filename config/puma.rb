  #!/usr/bin/env puma
  require 'puma/daemon'
  directory '/var/www/campaign_app/current'
  rackup "/var/www/campaign_app/current/config.ru"
  environment 'staging'

  tag ''

  pidfile "/var/www/campaign_app/shared/tmp/pids/puma.pid"
  state_path "/var/www/campaign_app/shared/tmp/pids/puma.state"
  stdout_redirect '/var/www/campaign_app/current/log/puma.error.log', '/var/www/campaign_app/current/log/puma.access.log', true


  threads 4,16



  bind 'unix:///var/www/campaign_app/shared/tmp/sockets/campaign_app-puma.sock'

  workers 4




  restart_command 'bundle exec puma'


  preload_app!


  on_restart do
    puts 'Refreshing Gemfile'
    ENV["BUNDLE_GEMFILE"] = ""
  end


  before_fork do
    ActiveRecord::Base.connection_pool.disconnect!
  end

  on_worker_boot do
    ActiveSupport.on_load(:active_record) do
      ActiveRecord::Base.establish_connection
    end
  end

  daemonize