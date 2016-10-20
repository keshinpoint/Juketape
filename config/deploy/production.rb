set :rails_env, :production
server '52.34.233.246', user: 'deploy', roles: %w{web app db sync_networks}, primary: true
