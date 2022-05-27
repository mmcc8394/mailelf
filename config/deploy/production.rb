set :application, 'mailelf.techunwreck.com'
set :deploy_to, '/var/deploy/mailelf.techunwreck.com'
set :rails_env, 'production'

server 'mailelf.techunwreck.com', user: 'deploy', roles: %w{app db web}

append :linked_files, 'config/database.yml', 'config/master.key'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets'