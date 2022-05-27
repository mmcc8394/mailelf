# config valid for current version and patch releases of Capistrano
lock "~> 3.14.0"

set :repo_url, "git@github.com:mmcc8394/mailelf.git"

set :use_sudo, false
set :deploy_via, :remote_cache
set :format, :pretty
set :log_level, :info
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/mailelf.techunwreck.com) }

set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.6.3@bulkmailer'
