set :rails_env, 'staging'
set :skip_deploy_tagging, true
# set :deploy_to, '/home/deploy/apps/juketape-staging'
server '52.34.233.246', user: 'deploy', roles: %w{web app db sync_networks}, primary: true
