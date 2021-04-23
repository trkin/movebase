# config valid for current version and patch releases of Capistrano
lock '~> 3.16.0'

set :application, 'movebase'
set :repo_url, 'git@github.com:trkin/move-index.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/ubuntu/#{fetch(:application)}"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', '.bundle', 'public/system', 'public/packs', 'public/packs'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :rbenv_ruby, '2.6.3'
set :rbenv_type, :user

set :assets_dependencies, %w[app/javascript app/assets vendor/assets Gemfile.lock yarn.lock]

# https://github.com/javan/whenever/blob/master/lib/whenever/capistrano/v3/tasks/whenever.rake
set :whenever_roles, -> { :worker }
# https://github.com/javan/whenever/wiki/rbenv-and-capistrano-Notes
set :whenever_environment, fetch(:stage)
set :whenever_variables, (lambda do
  "'environment=#{fetch :whenever_environment}" \
  "&rbenv_root=#{fetch :rbenv_path}'"
end)
