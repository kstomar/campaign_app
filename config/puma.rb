require 'puma/daemon'

workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup if defined?(DefaultRackup)
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

sidekiq_var = nil

on_worker_boot do
  # Worker-specific setup for Rails 4.1 to 5.2, after 5.2 it's not needed
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection

  sidekiq_var = Sidekiq.configure_embed do |config|
    config.logger.level = Logger::DEBUG
    config.logger = ActiveSupport::BroadcastLogger.new(
      ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new("log/sidekiq.log", formatter: Logger::Formatter.new))
    )
    config.queues = %w[critical default image_import image_export delete_platform export_data import_data special_day_offer import_order generate_access_token]
    config.concurrency = 20
  end
  sidekiq_var.run
end

on_worker_shutdown do
  sidekiq_var&.stop
end

daemonize