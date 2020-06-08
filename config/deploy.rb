# config valid for current version and patch releases of Capistrano
lock "~> 3.14.0"

set :repo_url, "git@github.com:mmcc8394/mailelf.git"

set :use_sudo, false
set :deploy_via, :remote_cache
set :format, :pretty
set :log_level, :info

set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.6.3@bulkmailer'

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

#set :pty, true
#set :ssh_options, {
#    forward_agent: true,
#    auth_methods: %w[publickey],
#    keys: %w[/Users/Matt/.ssh/id_mailelf]
#}

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5
