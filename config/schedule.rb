# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
# Learn more: http://github.com/javan/whenever

every 2.days, at: '6am' do
  rake 'sync_networks:sync_data', output: 'log/sync_networks.log'
end
