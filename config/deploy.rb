lock '3.6.1'

set :application, 'juketape'
set :repo_url, 'git@github.com:kesh92/juketape.git'

set :branch, :version2
if ENV['BRANCH']
  set :branch, ENV['BRANCH']
end

if ENV['DEPLOY_USER']
  set :tmp_dir, "/tmp/juketape-#{ENV['DEPLOY_USER']}"
end

set :scm, :git

if ENV['DEPLOY_ENV']
  set :rails_env, ENV['DEPLOY_ENV']
end

set :deploy_to, "/home/deploy/apps/juketape-#{fetch(:rails_env, 'production')}"
set :whenever_roles, -> {[:sync_networks]}

set :pty, true
# set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5
set :use_sudo, false
set :deploy_tag, Time.now.utc.strftime("%Y%m%d%H%M%S")

set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.3.0'

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  task :clear_cache do
    on roles(:app) do
      within current_path.to_s do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'cache:clear'
          execute :rake, 'tmp:cache:clear'
          execute "rm -rf #{shared_path}/tmp/cache"
          execute "rm -rf #{release_path}/tmp/cache"
        end
      end
    end
  end

  # To COPY the .env file from shared path to current path of the application repo
  task :copy_env do
    on roles(:app) do
      execute :cp, shared_path.join('.env'), release_path.join('.env')
    end
  end

  after :updating, :copy_env
  after :cleanup, :clear_cache
end
