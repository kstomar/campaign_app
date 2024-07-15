namespace :puma do
  desc 'Setup Puma config file'
  task :config do
    on roles(fetch(:puma_role)) do |role|
      template_puma 'puma', fetch(:puma_conf), role
    end
  end

  desc 'Start puma'
  task :start_echo do
    on roles(fetch(:puma_role)) do |role|
      puma_switch_user(role) do
        if test "[ -f #{fetch(:puma_conf)} ]"
          info "using conf file #{fetch(:puma_conf)}"
        else
          invoke 'puma:config'
        end
        within current_path do
          with rack_env: fetch(:puma_env) do
            execute("cd #{current_path} bundle exec puma -C /var/www/campaign_app/shared/puma.rb && sleep 5")
          end
        end
      end
    end
  end
end